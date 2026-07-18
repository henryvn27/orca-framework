#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "shellwords"
require "time"

class MissionError < StandardError; end

class OrcaMission
  def initialize(arguments)
    @arguments = arguments.dup
    separator = @arguments.index("--") || @arguments.length
    json_index = @arguments[0...separator].index("--json")
    @json = !json_index.nil?
    @arguments.delete_at(json_index) if json_index
    @orca_root = ENV.fetch("ORCA_ROOT", ".orca")
    @missions_dir = File.join(@orca_root, "missions")
    @active_path = File.join(@orca_root, "active-mission")
    @lock_path = File.join(@orca_root, "mission.lock")
  end

  def run
    command = @arguments.shift || "status"
    case command
    when "create" then create(@arguments)
    when "status" then status(@arguments)
    when "list" then list(@arguments)
    when "check" then check(@arguments)
    when "satisfy" then satisfy(@arguments)
    when "block" then block(@arguments)
    when "resume" then resume(@arguments)
    when "complete" then complete(@arguments)
    when "help", "-h", "--help" then usage
    else raise MissionError, "unknown mission command: #{command}"
    end
  rescue MissionError => error
    if @json
      puts JSON.generate(ok: false, error: error.message)
    else
      warn "orca mission: #{error.message}"
    end
    2
  end

  private

  def usage
    puts <<~TEXT
      Usage:
        orca mission create OUTCOME --criterion TEXT [--criterion TEXT ...] [--json]
        orca mission status [--json]
        orca mission list [--json]
        orca mission check AC-ID [--json] -- COMMAND [ARG ...]
        orca mission satisfy AC-ID --evidence TEXT [--json]
        orca mission block REASON [--json]
        orca mission resume [--json]
        orca mission complete [--json]
    TEXT
    0
  end

  def create(arguments)
    outcome = nil
    criteria = []
    until arguments.empty?
      argument = arguments.shift
      case argument
      when "--criterion"
        criteria << required_value(arguments, "--criterion")
      when "-h", "--help"
        return usage
      when /^--/
        raise MissionError, "unknown create option: #{argument}"
      else
        raise MissionError, "create accepts one quoted outcome" if outcome
        outcome = argument
      end
    end
    raise MissionError, "create requires an outcome" if outcome.to_s.strip.empty?
    raise MissionError, "create requires at least one --criterion" if criteria.empty?
    raise MissionError, "criteria cannot be blank" if criteria.any? { |criterion| criterion.strip.empty? }
    raise MissionError, "criteria must be unique" unless criteria.map(&:strip).uniq.length == criteria.length

    with_lock do
      active = active_mission(required: false)
      if active && active.fetch("status") != "completed"
        raise MissionError, "mission #{active.fetch("id")} is still #{active.fetch("status")}; complete it before creating another"
      end

      timestamp = now
      id = unique_id(outcome, timestamp)
      mission = {
        "schema_version" => "1.0.0",
        "product" => "orca_mission",
        "id" => id,
        "outcome" => outcome.strip,
        "status" => "active",
        "criteria" => criteria.each_with_index.map do |text, index|
          {
            "id" => "AC-#{index + 1}",
            "text" => text.strip,
            "status" => "open",
            "evidence" => []
          }
        end,
        "blockers" => [],
        "events" => [{ "type" => "mission_created", "at" => timestamp }],
        "created_at" => timestamp,
        "updated_at" => timestamp,
        "completed_at" => nil
      }
      persist(mission)
      atomic_write(@active_path, "#{id}\n")
      emit(mission, "Mission created")
    end
    0
  end

  def status(arguments)
    no_arguments!(arguments, "status")
    mission = active_mission
    emit(mission)
    0
  end

  def list(arguments)
    no_arguments!(arguments, "list")
    missions = Dir[File.join(@missions_dir, "*.json")].sort.map { |path| load_mission(path) }
    active_id = File.file?(@active_path) ? File.read(@active_path).strip : nil
    summaries = missions.map do |mission|
      {
        "id" => mission.fetch("id"),
        "outcome" => mission.fetch("outcome"),
        "status" => mission.fetch("status"),
        "readiness" => readiness(mission),
        "active" => mission.fetch("id") == active_id,
        "updated_at" => mission.fetch("updated_at")
      }
    end
    if @json
      puts JSON.generate(ok: true, missions: summaries)
    elsif summaries.empty?
      puts "No Orca missions yet."
    else
      summaries.each do |mission|
        marker = mission.fetch("active") ? "*" : " "
        score = mission.fetch("readiness").fetch("percent")
        puts "#{marker} #{mission.fetch("id")}  #{mission.fetch("status")}  #{score}%  #{mission.fetch("outcome")}"
      end
    end
    0
  end

  def check(arguments)
    criterion_id = required_argument(arguments, "check requires an AC-ID")
    separator = arguments.index("--")
    raise MissionError, "check requires -- followed by a command" unless separator
    raise MissionError, "unknown check options: #{arguments[0...separator].join(" ")}" unless separator.zero?
    command = arguments[(separator + 1)..]
    raise MissionError, "check requires a command after --" if command.empty?

    with_lock do
      mission = active_mission
      require_active!(mission)
      criterion = criterion!(mission, criterion_id)
      command_text = Shellwords.join(command)
      $stderr.puts "$ #{command_text}" if @json
      $stdout.puts "$ #{command_text}" unless @json
      pid = Process.spawn(*command, out: (@json ? $stderr : $stdout), err: $stderr)
      Process.wait(pid)
      exit_code = $?.exitstatus || 128 + $?.termsig
      event = { "type" => "criterion_checked", "criterion_id" => criterion.fetch("id"), "command" => command_text, "exit_code" => exit_code, "at" => now }
      mission.fetch("events") << event
      if exit_code.zero?
        criterion["status"] = "satisfied"
        criterion.fetch("evidence") << { "type" => "command", "command" => command_text, "exit_code" => exit_code, "recorded_at" => now }
        touch(mission)
        persist(mission)
        emit(mission, "#{criterion.fetch("id")} satisfied by command")
        return 0
      end
      touch(mission)
      persist(mission)
      raise MissionError, "#{criterion.fetch("id")} check failed with exit #{exit_code}"
    rescue Errno::ENOENT => error
      raise MissionError, "check command not found: #{error.message}"
    end
  end

  def satisfy(arguments)
    criterion_id = required_argument(arguments, "satisfy requires an AC-ID")
    evidence = nil
    until arguments.empty?
      argument = arguments.shift
      case argument
      when "--evidence" then evidence = required_value(arguments, "--evidence")
      else raise MissionError, "unknown satisfy option: #{argument}"
      end
    end
    raise MissionError, "satisfy requires --evidence" if evidence.to_s.strip.empty?

    mutate_active do |mission|
      require_active!(mission)
      criterion = criterion!(mission, criterion_id)
      criterion["status"] = "satisfied"
      criterion.fetch("evidence") << { "type" => "attestation", "summary" => evidence.strip, "recorded_at" => now }
      mission.fetch("events") << { "type" => "criterion_satisfied", "criterion_id" => criterion.fetch("id"), "at" => now }
      "#{criterion.fetch("id")} satisfied with evidence"
    end
  end

  def block(arguments)
    reason = arguments.join(" ").strip
    raise MissionError, "block requires a reason" if reason.empty?
    mutate_active do |mission|
      require_active!(mission)
      mission["status"] = "blocked"
      mission.fetch("blockers") << { "reason" => reason, "created_at" => now, "resolved_at" => nil }
      mission.fetch("events") << { "type" => "mission_blocked", "reason" => reason, "at" => now }
      "Mission blocked"
    end
  end

  def resume(arguments)
    no_arguments!(arguments, "resume")
    mutate_active do |mission|
      raise MissionError, "mission is not blocked" unless mission.fetch("status") == "blocked"
      mission.fetch("blockers").each { |blocker| blocker["resolved_at"] ||= now }
      mission["status"] = "active"
      mission.fetch("events") << { "type" => "mission_resumed", "at" => now }
      "Mission resumed"
    end
  end

  def complete(arguments)
    no_arguments!(arguments, "complete")
    mutate_active do |mission|
      require_active!(mission)
      open_criteria = mission.fetch("criteria").reject { |criterion| criterion.fetch("status") == "satisfied" && !criterion.fetch("evidence").empty? }
      unless open_criteria.empty?
        raise MissionError, "cannot complete; evidence is still required for #{open_criteria.map { |criterion| criterion.fetch("id") }.join(", ")}"
      end
      mission["status"] = "completed"
      mission["completed_at"] = now
      mission.fetch("events") << { "type" => "mission_completed", "at" => now }
      "Mission completed"
    end
  end

  def mutate_active
    with_lock do
      mission = active_mission
      message = yield mission
      touch(mission)
      persist(mission)
      emit(mission, message)
    end
    0
  end

  def with_lock
    FileUtils.mkdir_p(@orca_root)
    File.open(@lock_path, File::RDWR | File::CREAT, 0o600) do |lock|
      lock.flock(File::LOCK_EX)
      yield
    end
  end

  def active_mission(required: true)
    unless File.file?(@active_path)
      raise MissionError, "no active mission; run `orca mission create ...`" if required
      return nil
    end
    id = File.read(@active_path).strip
    raise MissionError, "active mission pointer is invalid" unless id.match?(/\A[a-z0-9][a-z0-9-]{0,119}\z/)
    path = File.join(@missions_dir, "#{id}.json")
    raise MissionError, "active mission state is missing: #{path}" unless File.file?(path)
    load_mission(path)
  end

  def load_mission(path)
    mission = JSON.parse(File.read(path))
    raise MissionError, "unsupported mission schema in #{path}" unless mission["schema_version"] == "1.0.0"
    required = %w[id outcome status criteria blockers events created_at updated_at]
    missing = required.reject { |field| mission.key?(field) }
    raise MissionError, "mission state is missing #{missing.join(", ")} in #{path}" unless missing.empty?
    raise MissionError, "mission criteria are invalid in #{path}" unless mission["criteria"].is_a?(Array) && !mission["criteria"].empty?
    raise MissionError, "mission blockers are invalid in #{path}" unless mission["blockers"].is_a?(Array)
    raise MissionError, "mission events are invalid in #{path}" unless mission["events"].is_a?(Array)
    mission
  rescue JSON::ParserError => error
    raise MissionError, "invalid mission state in #{path}: #{error.message}"
  end

  def persist(mission)
    FileUtils.mkdir_p(@missions_dir)
    touch(mission)
    atomic_write(File.join(@missions_dir, "#{mission.fetch("id")}.json"), JSON.pretty_generate(public_state(mission)) + "\n")
  end

  def atomic_write(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    temporary = "#{path}.tmp.#{$$}"
    File.open(temporary, File::WRONLY | File::CREAT | File::TRUNC, 0o600) do |file|
      file.write(content)
      file.flush
      file.fsync
    end
    File.rename(temporary, path)
  ensure
    File.delete(temporary) if defined?(temporary) && File.exist?(temporary)
  end

  def public_state(mission)
    mission.merge("readiness" => readiness(mission), "next_action" => next_action(mission))
  end

  def readiness(mission)
    total = mission.fetch("criteria").length
    satisfied = mission.fetch("criteria").count { |criterion| criterion.fetch("status") == "satisfied" && !criterion.fetch("evidence").empty? }
    unresolved = mission.fetch("blockers").count { |blocker| blocker["resolved_at"].nil? }
    {
      "satisfied" => satisfied,
      "total" => total,
      "percent" => total.zero? ? 0 : satisfied * 100 / total,
      "unresolved_blockers" => unresolved,
      "ready_to_complete" => satisfied == total && unresolved.zero? && mission.fetch("status") == "active"
    }
  end

  def next_action(mission)
    return "Mission complete." if mission.fetch("status") == "completed"
    blocker = mission.fetch("blockers").find { |item| item["resolved_at"].nil? }
    return "Resolve blocker: #{blocker.fetch("reason")}" if blocker
    criterion = mission.fetch("criteria").find { |item| item.fetch("status") != "satisfied" || item.fetch("evidence").empty? }
    return "Prove #{criterion.fetch("id")}: #{criterion.fetch("text")}" if criterion
    "Run `orca mission complete`."
  end

  def emit(mission, message = nil)
    state = public_state(mission)
    if @json
      puts JSON.generate(ok: true, mission: state)
      return
    end
    puts message if message
    score = state.fetch("readiness")
    puts ""
    puts "ORCA MISSION  #{state.fetch("id")}"
    puts state.fetch("outcome")
    puts "Status: #{state.fetch("status").upcase}  |  Readiness: #{score.fetch("satisfied")}/#{score.fetch("total")} (#{score.fetch("percent")}%)"
    puts ""
    puts "Acceptance criteria"
    state.fetch("criteria").each do |criterion|
      mark = criterion.fetch("status") == "satisfied" && !criterion.fetch("evidence").empty? ? "x" : " "
      puts "[#{mark}] #{criterion.fetch("id")}  #{criterion.fetch("text")}"
      criterion.fetch("evidence").each do |evidence|
        detail = evidence["summary"] || "#{evidence.fetch("command")} (exit #{evidence.fetch("exit_code")})"
        puts "    evidence: #{detail}"
      end
    end
    unresolved = state.fetch("blockers").select { |blocker| blocker["resolved_at"].nil? }
    unless unresolved.empty?
      puts ""
      puts "Blockers"
      unresolved.each { |blocker| puts "[!] #{blocker.fetch("reason")}" }
    end
    puts ""
    puts "Next: #{state.fetch("next_action")}"
    puts "State: #{File.join(@missions_dir, "#{state.fetch("id")}.json")}"
  end

  def criterion!(mission, id)
    criterion = mission.fetch("criteria").find { |item| item.fetch("id").casecmp?(id) }
    raise MissionError, "unknown criterion: #{id}" unless criterion
    criterion
  end

  def require_active!(mission)
    raise MissionError, "mission is blocked; resolve the blocker and run `orca mission resume`" if mission.fetch("status") == "blocked"
    raise MissionError, "mission is already completed" if mission.fetch("status") == "completed"
  end

  def unique_id(outcome, timestamp)
    slug = slugify(outcome)
    slug = "mission" if slug.empty?
    base = "#{timestamp.delete("-:").sub("+0000", "").sub("Z", "").downcase}-#{slug}"
    candidate = base
    suffix = 2
    while File.exist?(File.join(@missions_dir, "#{candidate}.json"))
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    candidate
  end

  def slugify(value)
    value.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "")[0, 60]
  end

  def touch(mission)
    mission["updated_at"] = now
    mission.delete("readiness")
    mission.delete("next_action")
  end

  def now
    Time.now.utc.iso8601
  end

  def required_argument(arguments, message)
    value = arguments.shift
    raise MissionError, message if value.to_s.empty? || value.start_with?("--")
    value
  end

  def required_value(arguments, option)
    value = arguments.shift
    raise MissionError, "#{option} requires a value" if value.to_s.empty? || value.start_with?("--")
    value
  end

  def no_arguments!(arguments, command)
    raise MissionError, "#{command} does not accept arguments: #{arguments.join(" ")}" unless arguments.empty?
  end
end

exit OrcaMission.new(ARGV).run
