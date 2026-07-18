#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "shellwords"
require "time"

class MissionError < StandardError; end

class OrcaMission
  SCHEMA_VERSION = "1.0.0"
  EXPORT_VERSION = "1.0.0"
  STATUSES = %w[active blocked completed canceled].freeze
  TERMINAL_STATUSES = %w[completed canceled].freeze

  def initialize(arguments)
    @arguments = arguments.dup
    separator = @arguments.index("--") || @arguments.length
    json_index = @arguments[0...separator].index("--json")
    @json = !json_index.nil?
    @arguments.delete_at(json_index) if json_index
    @orca_root = File.expand_path(ENV.fetch("ORCA_ROOT", ".orca"))
    @missions_dir = File.join(@orca_root, "missions")
    @active_path = File.join(@orca_root, "active-mission")
    @lock_path = File.join(@orca_root, "mission.lock")
  end

  def run
    command = @arguments.shift || "status"
    case command
    when "create" then create(@arguments)
    when "status" then status(@arguments)
    when "show" then show(@arguments)
    when "list" then list(@arguments)
    when "events" then events(@arguments)
    when "add" then add(@arguments)
    when "reset" then reset(@arguments)
    when "check" then check(@arguments)
    when "satisfy" then satisfy(@arguments)
    when "note" then note(@arguments)
    when "block" then block(@arguments)
    when "resume" then resume(@arguments)
    when "cancel" then cancel(@arguments)
    when "reopen" then reopen(@arguments)
    when "complete" then complete(@arguments)
    when "validate" then validate(@arguments)
    when "export" then export_mission(@arguments)
    when "import" then import_mission(@arguments)
    when "help", "-h", "--help" then usage
    else raise MissionError, "unknown mission command: #{command}"
    end
  rescue MissionError, SystemCallError => error
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
        orca mission create OUTCOME --criterion TEXT [--criterion TEXT ...] [--by ACTOR] [--json]
        orca mission status [--json]
        orca mission show [MISSION-ID] [--json]
        orca mission list [--json]
        orca mission events [MISSION-ID] [--json]
        orca mission add --criterion TEXT [--by ACTOR] [--json]
        orca mission reset AC-ID --reason TEXT [--by ACTOR] [--json]
        orca mission check AC-ID [--by ACTOR] [--json] -- COMMAND [ARG ...]
        orca mission satisfy AC-ID --evidence TEXT [--by ACTOR] [--json]
        orca mission note TEXT [--by ACTOR] [--json]
        orca mission block REASON [--by ACTOR] [--json]
        orca mission resume [--reason TEXT] [--by ACTOR] [--json]
        orca mission cancel REASON [--by ACTOR] [--json]
        orca mission reopen MISSION-ID --reason TEXT [--by ACTOR] [--json]
        orca mission complete [--by ACTOR] [--json]
        orca mission validate [MISSION-ID] [--json]
        orca mission export [MISSION-ID] --output PATH [--force] [--json]
        orca mission import PATH [--json]
    TEXT
    0
  end

  def create(arguments)
    outcome = nil
    criteria = []
    actor = nil
    until arguments.empty?
      argument = arguments.shift
      case argument
      when "--criterion" then criteria << required_value(arguments, "--criterion")
      when "--by" then actor = unique_option(actor, required_value(arguments, "--by"), "--by")
      when "-h", "--help" then return usage
      when /^--/ then raise MissionError, "unknown create option: #{argument}"
      else
        raise MissionError, "create accepts one quoted outcome" if outcome
        outcome = argument
      end
    end
    actor = actor_name(actor)
    raise MissionError, "create requires an outcome" if outcome.to_s.strip.empty?
    raise MissionError, "create requires at least one --criterion" if criteria.empty?
    validate_criterion_texts!(criteria)

    with_lock do
      active = active_mission(required: false)
      if active && !TERMINAL_STATUSES.include?(active.fetch("status"))
        raise MissionError, "mission #{active.fetch("id")} is still #{active.fetch("status")}; complete or cancel it before creating another"
      end

      timestamp = now
      id = unique_id(outcome, timestamp)
      mission = {
        "schema_version" => SCHEMA_VERSION,
        "product" => "orca_mission",
        "id" => id,
        "outcome" => outcome.strip,
        "status" => "active",
        "revision" => 1,
        "criteria" => criteria.each_with_index.map do |text, index|
          { "id" => "AC-#{index + 1}", "text" => text.strip, "status" => "open", "evidence" => [] }
        end,
        "blockers" => [],
        "notes" => [],
        "events" => [{ "type" => "mission_created", "actor" => actor, "at" => timestamp }],
        "created_at" => timestamp,
        "updated_at" => timestamp,
        "completed_at" => nil,
        "canceled_at" => nil
      }
      persist(mission)
      atomic_write(@active_path, "#{id}\n")
      emit(mission, "Mission created")
    end
    0
  end

  def status(arguments)
    no_arguments!(arguments, "status")
    emit(active_mission)
    0
  end

  def show(arguments)
    identifier = optional_identifier(arguments, "show")
    emit(mission_for(identifier))
    0
  end

  def list(arguments)
    no_arguments!(arguments, "list")
    missions = mission_files.map { |path| load_mission(path) }
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

  def events(arguments)
    identifier = optional_identifier(arguments, "events")
    mission = mission_for(identifier)
    if @json
      puts JSON.generate(ok: true, mission_id: mission.fetch("id"), events: mission.fetch("events"))
    else
      mission.fetch("events").each do |event|
        detail = event["reason"] || event["summary"] || event["criterion_id"] || event["command"]
        puts [event.fetch("at"), event.fetch("type"), event.fetch("actor", "unknown"), detail].compact.join("  ")
      end
    end
    0
  end

  def add(arguments)
    text = take_option!(arguments, "--criterion")
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "add")
    raise MissionError, "add requires --criterion" if text.to_s.strip.empty?

    mutate_active do |mission|
      require_active!(mission)
      validate_criterion_texts!(mission.fetch("criteria").map { |item| item.fetch("text") } + [text])
      next_number = mission.fetch("criteria").map { |item| item.fetch("id").sub("AC-", "").to_i }.max.to_i + 1
      criterion = { "id" => "AC-#{next_number}", "text" => text.strip, "status" => "open", "evidence" => [] }
      mission.fetch("criteria") << criterion
      mission.fetch("events") << { "type" => "criterion_added", "criterion_id" => criterion.fetch("id"), "actor" => actor, "at" => now }
      "#{criterion.fetch("id")} added"
    end
  end

  def reset(arguments)
    criterion_id = required_argument(arguments, "reset requires an AC-ID")
    reason = take_option!(arguments, "--reason")
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "reset")
    raise MissionError, "reset requires --reason" if reason.to_s.strip.empty?

    mutate_active do |mission|
      require_active!(mission)
      criterion = criterion!(mission, criterion_id)
      raise MissionError, "#{criterion.fetch("id")} is already open" if criterion.fetch("status") == "open"
      criterion["status"] = "open"
      criterion["evidence"] = []
      mission.fetch("events") << {
        "type" => "criterion_reset",
        "criterion_id" => criterion.fetch("id"),
        "reason" => reason.strip,
        "actor" => actor,
        "at" => now
      }
      "#{criterion.fetch("id")} reset"
    end
  end

  def check(arguments)
    criterion_id = required_argument(arguments, "check requires an AC-ID")
    separator = arguments.index("--")
    raise MissionError, "check requires -- followed by a command" unless separator
    options = arguments[0...separator]
    actor = actor_name(take_option!(options, "--by"))
    raise MissionError, "unknown check options: #{options.join(" ")}" unless options.empty?
    command = arguments[(separator + 1)..]
    raise MissionError, "check requires a command after --" if command.empty?

    with_lock do
      mission = active_mission
      require_active!(mission)
      criterion = criterion!(mission, criterion_id)
      command_text = Shellwords.join(command)
      $stderr.puts "$ #{command_text}" if @json
      $stdout.puts "$ #{command_text}" unless @json
      started_at = now
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      pid = Process.spawn(*command, out: (@json ? $stderr : $stdout), err: $stderr)
      Process.wait(pid)
      exit_code = $?.exitstatus || 128 + $?.termsig
      finished_at = now
      duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round
      event = {
        "type" => "criterion_checked",
        "criterion_id" => criterion.fetch("id"),
        "command" => command_text,
        "exit_code" => exit_code,
        "duration_ms" => duration_ms,
        "actor" => actor,
        "at" => finished_at
      }
      mission.fetch("events") << event
      if exit_code.zero?
        criterion["status"] = "satisfied"
        criterion.fetch("evidence") << {
          "type" => "command",
          "command" => command_text,
          "exit_code" => exit_code,
          "started_at" => started_at,
          "recorded_at" => finished_at,
          "duration_ms" => duration_ms,
          "actor" => actor
        }
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
    evidence = take_option!(arguments, "--evidence")
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "satisfy")
    raise MissionError, "satisfy requires --evidence" if evidence.to_s.strip.empty?

    mutate_active do |mission|
      require_active!(mission)
      criterion = criterion!(mission, criterion_id)
      criterion["status"] = "satisfied"
      criterion.fetch("evidence") << {
        "type" => "attestation",
        "summary" => evidence.strip,
        "actor" => actor,
        "recorded_at" => now
      }
      mission.fetch("events") << {
        "type" => "criterion_satisfied",
        "criterion_id" => criterion.fetch("id"),
        "summary" => evidence.strip,
        "actor" => actor,
        "at" => now
      }
      "#{criterion.fetch("id")} satisfied with evidence"
    end
  end

  def note(arguments)
    actor = actor_name(take_option!(arguments, "--by"))
    summary = arguments.join(" ").strip
    raise MissionError, "note requires text" if summary.empty?

    mutate_active do |mission|
      entry = { "summary" => summary, "actor" => actor, "recorded_at" => now }
      mission.fetch("notes") << entry
      mission.fetch("events") << { "type" => "note_added", "summary" => summary, "actor" => actor, "at" => now }
      "Note added"
    end
  end

  def block(arguments)
    actor = actor_name(take_option!(arguments, "--by"))
    reason = arguments.join(" ").strip
    raise MissionError, "block requires a reason" if reason.empty?

    mutate_active do |mission|
      require_active!(mission)
      mission["status"] = "blocked"
      mission.fetch("blockers") << {
        "reason" => reason,
        "actor" => actor,
        "created_at" => now,
        "resolved_at" => nil,
        "resolved_by" => nil,
        "resolution" => nil
      }
      mission.fetch("events") << { "type" => "mission_blocked", "reason" => reason, "actor" => actor, "at" => now }
      "Mission blocked"
    end
  end

  def resume(arguments)
    reason = take_option!(arguments, "--reason")
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "resume")
    reason = reason.to_s.strip
    reason = "Blocker resolved" if reason.empty?

    mutate_active do |mission|
      raise MissionError, "mission is not blocked" unless mission.fetch("status") == "blocked"
      timestamp = now
      mission.fetch("blockers").each do |blocker|
        next unless blocker["resolved_at"].nil?
        blocker["resolved_at"] = timestamp
        blocker["resolved_by"] = actor
        blocker["resolution"] = reason
      end
      mission["status"] = "active"
      mission.fetch("events") << { "type" => "mission_resumed", "reason" => reason, "actor" => actor, "at" => timestamp }
      "Mission resumed"
    end
  end

  def cancel(arguments)
    actor = actor_name(take_option!(arguments, "--by"))
    reason = arguments.join(" ").strip
    raise MissionError, "cancel requires a reason" if reason.empty?

    mutate_active do |mission|
      raise MissionError, "mission is already #{mission.fetch("status")}" if TERMINAL_STATUSES.include?(mission.fetch("status"))
      timestamp = now
      mission.fetch("blockers").each do |blocker|
        next unless blocker["resolved_at"].nil?
        blocker["resolved_at"] = timestamp
        blocker["resolved_by"] = actor
        blocker["resolution"] = "Mission canceled: #{reason}"
      end
      mission["status"] = "canceled"
      mission["canceled_at"] = timestamp
      mission.fetch("events") << { "type" => "mission_canceled", "reason" => reason, "actor" => actor, "at" => timestamp }
      "Mission canceled"
    end
  end

  def reopen(arguments)
    identifier = required_argument(arguments, "reopen requires a MISSION-ID")
    reason = take_option!(arguments, "--reason")
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "reopen")
    raise MissionError, "reopen requires --reason" if reason.to_s.strip.empty?

    with_lock do
      current = active_mission(required: false)
      if current && current.fetch("id") != identifier && !TERMINAL_STATUSES.include?(current.fetch("status"))
        raise MissionError, "mission #{current.fetch("id")} is still #{current.fetch("status")}; complete or cancel it before reopening another"
      end
      mission = mission_for(identifier)
      raise MissionError, "mission #{identifier} is not completed or canceled" unless TERMINAL_STATUSES.include?(mission.fetch("status"))
      previous_status = mission.fetch("status")
      mission["status"] = "active"
      mission["completed_at"] = nil
      mission["canceled_at"] = nil
      mission.fetch("events") << {
        "type" => "mission_reopened",
        "reason" => reason.strip,
        "previous_status" => previous_status,
        "actor" => actor,
        "at" => now
      }
      touch(mission)
      persist(mission)
      atomic_write(@active_path, "#{identifier}\n")
      emit(mission, "Mission reopened")
    end
    0
  end

  def complete(arguments)
    actor = actor_name(take_option!(arguments, "--by"))
    no_arguments!(arguments, "complete")

    mutate_active do |mission|
      require_active!(mission)
      open_criteria = mission.fetch("criteria").reject { |criterion| satisfied?(criterion) }
      unless open_criteria.empty?
        raise MissionError, "cannot complete; evidence is still required for #{open_criteria.map { |criterion| criterion.fetch("id") }.join(", ")}"
      end
      mission["status"] = "completed"
      mission["completed_at"] = now
      mission.fetch("events") << { "type" => "mission_completed", "actor" => actor, "at" => now }
      "Mission completed"
    end
  end

  def validate(arguments)
    identifier = optional_identifier(arguments, "validate")
    mission = mission_for(identifier)
    validate_mission!(mission, mission.fetch("id"))
    if @json
      puts JSON.generate(ok: true, mission_id: mission.fetch("id"), valid: true, schema_version: mission.fetch("schema_version"))
    else
      puts "Mission #{mission.fetch("id")} is valid (schema #{mission.fetch("schema_version")})."
    end
    0
  end

  def export_mission(arguments)
    output = take_option!(arguments, "--output")
    force = take_flag!(arguments, "--force")
    identifier = optional_identifier(arguments, "export")
    raise MissionError, "export requires --output" if output.to_s.strip.empty?
    output = File.expand_path(output)
    raise MissionError, "export target already exists: #{output}; use --force to replace it" if File.exist?(output) && !force

    mission = mission_for(identifier)
    envelope = {
      "format" => "orca_mission_export",
      "format_version" => EXPORT_VERSION,
      "exported_at" => now,
      "mission" => public_state(mission)
    }
    atomic_write(output, JSON.pretty_generate(envelope) + "\n")
    if @json
      puts JSON.generate(ok: true, mission_id: mission.fetch("id"), path: output)
    else
      puts "Mission #{mission.fetch("id")} exported to #{output}"
    end
    0
  end

  def import_mission(arguments)
    path = required_argument(arguments, "import requires a PATH")
    no_arguments!(arguments, "import")
    path = File.expand_path(path)
    payload = JSON.parse(File.read(path))
    unless payload.is_a?(Hash) && payload["format"] == "orca_mission_export" && payload["format_version"] == EXPORT_VERSION
      raise MissionError, "unsupported Orca Mission export: #{path}"
    end
    mission = normalize_mission(payload.fetch("mission"))
    validate_mission!(mission, path)

    with_lock do
      active = active_mission(required: false)
      if !TERMINAL_STATUSES.include?(mission.fetch("status")) && active && active.fetch("id") != mission.fetch("id") && !TERMINAL_STATUSES.include?(active.fetch("status"))
        raise MissionError, "cannot import active mission while #{active.fetch("id")} is still #{active.fetch("status")}"
      end
      existing_path = mission_path(mission.fetch("id"))
      if File.file?(existing_path)
        existing = load_mission(existing_path)
        unless core_state(existing) == core_state(mission)
          raise MissionError, "mission #{mission.fetch("id")} already exists with different state"
        end
      else
        persist(mission)
      end
      atomic_write(@active_path, "#{mission.fetch("id")}\n") unless TERMINAL_STATUSES.include?(mission.fetch("status"))
      emit(mission_for(mission.fetch("id")), "Mission imported")
    end
    0
  rescue JSON::ParserError => error
    raise MissionError, "invalid mission export in #{path}: #{error.message}"
  rescue KeyError => error
    raise MissionError, "mission export is missing #{error.key} in #{path}"
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
    identifier = File.read(@active_path).strip
    validate_identifier!(identifier)
    path = mission_path(identifier)
    raise MissionError, "active mission state is missing: #{path}" unless File.file?(path)
    load_mission(path)
  end

  def mission_for(identifier)
    return active_mission if identifier.to_s.empty?
    validate_identifier!(identifier)
    path = mission_path(identifier)
    raise MissionError, "mission state is missing: #{path}" unless File.file?(path)
    load_mission(path)
  end

  def mission_files
    Dir[File.join(@missions_dir, "*.json")].sort
  end

  def mission_path(identifier)
    File.join(@missions_dir, "#{identifier}.json")
  end

  def load_mission(path)
    mission = normalize_mission(JSON.parse(File.read(path)))
    validate_mission!(mission, path)
    mission
  rescue JSON::ParserError => error
    raise MissionError, "invalid mission state in #{path}: #{error.message}"
  end

  def normalize_mission(mission)
    raise MissionError, "mission state must be a JSON object" unless mission.is_a?(Hash)
    mission = JSON.parse(JSON.generate(mission))
    mission["product"] ||= "orca_mission"
    mission["revision"] ||= 1
    mission["notes"] ||= []
    mission["completed_at"] = nil unless mission.key?("completed_at")
    mission["canceled_at"] = nil unless mission.key?("canceled_at")
    Array(mission["criteria"]).each do |criterion|
      Array(criterion["evidence"]).each { |evidence| evidence["actor"] ||= "unknown" }
    end
    Array(mission["blockers"]).each do |blocker|
      blocker["actor"] ||= "unknown"
      if blocker["resolved_at"]
        blocker["resolved_by"] ||= "unknown"
        blocker["resolution"] ||= "Resolved before Orca 1.0"
      else
        blocker["resolved_by"] = nil unless blocker.key?("resolved_by")
        blocker["resolution"] = nil unless blocker.key?("resolution")
      end
    end
    Array(mission["notes"]).each { |entry| entry["actor"] ||= "unknown" }
    Array(mission["events"]).each { |event| event["actor"] ||= "unknown" }
    mission.delete("readiness")
    mission.delete("next_action")
    mission
  end

  def validate_mission!(mission, source)
    required = %w[schema_version product id outcome status revision criteria blockers notes events created_at updated_at]
    missing = required.reject { |field| mission.key?(field) }
    raise MissionError, "mission state is missing #{missing.join(", ")} in #{source}" unless missing.empty?
    raise MissionError, "unsupported mission schema in #{source}" unless mission["schema_version"] == SCHEMA_VERSION
    raise MissionError, "invalid mission product in #{source}" unless mission["product"] == "orca_mission"
    validate_identifier!(mission["id"])
    raise MissionError, "mission outcome is blank in #{source}" if mission["outcome"].to_s.strip.empty?
    raise MissionError, "mission status is invalid in #{source}" unless STATUSES.include?(mission["status"])
    raise MissionError, "mission revision is invalid in #{source}" unless mission["revision"].is_a?(Integer) && mission["revision"].positive?
    validate_timestamp!(mission["created_at"], "created_at", source)
    validate_timestamp!(mission["updated_at"], "updated_at", source)

    criteria = mission["criteria"]
    raise MissionError, "mission criteria are invalid in #{source}" unless criteria.is_a?(Array) && !criteria.empty?
    ids = []
    texts = []
    criteria.each do |criterion|
      raise MissionError, "mission criterion is invalid in #{source}" unless criterion.is_a?(Hash)
      identifier = criterion["id"]
      raise MissionError, "criterion id is invalid in #{source}" unless identifier.to_s.match?(/\AAC-[1-9][0-9]*\z/)
      raise MissionError, "duplicate criterion id #{identifier} in #{source}" if ids.include?(identifier)
      ids << identifier
      text = criterion["text"].to_s.strip
      raise MissionError, "criterion #{identifier} is blank in #{source}" if text.empty?
      raise MissionError, "duplicate criterion text in #{source}" if texts.include?(text.downcase)
      texts << text.downcase
      raise MissionError, "criterion #{identifier} status is invalid in #{source}" unless %w[open satisfied].include?(criterion["status"])
      evidence = criterion["evidence"]
      raise MissionError, "criterion #{identifier} evidence is invalid in #{source}" unless evidence.is_a?(Array)
      evidence.each { |entry| validate_evidence!(entry, identifier, source) }
      if criterion["status"] == "satisfied" && evidence.empty?
        raise MissionError, "criterion #{identifier} is satisfied without evidence in #{source}"
      end
      if criterion["status"] == "open" && !evidence.empty?
        raise MissionError, "criterion #{identifier} is open but still has evidence in #{source}"
      end
    end

    blockers = mission["blockers"]
    raise MissionError, "mission blockers are invalid in #{source}" unless blockers.is_a?(Array)
    blockers.each { |blocker| validate_blocker!(blocker, source) }
    unresolved = blockers.count { |blocker| blocker["resolved_at"].nil? }
    raise MissionError, "blocked mission has no unresolved blocker in #{source}" if mission["status"] == "blocked" && unresolved.zero?
    raise MissionError, "non-blocked mission has unresolved blockers in #{source}" if mission["status"] != "blocked" && unresolved.positive?

    raise MissionError, "mission notes are invalid in #{source}" unless mission["notes"].is_a?(Array)
    mission["notes"].each { |entry| validate_note!(entry, source) }
    raise MissionError, "mission events are invalid in #{source}" unless mission["events"].is_a?(Array) && !mission["events"].empty?
    mission["events"].each { |event| validate_event!(event, source) }

    case mission["status"]
    when "completed"
      raise MissionError, "completed mission has open criteria in #{source}" unless criteria.all? { |criterion| satisfied?(criterion) }
      validate_timestamp!(mission["completed_at"], "completed_at", source)
      raise MissionError, "completed mission has canceled_at in #{source}" unless mission["canceled_at"].nil?
    when "canceled"
      validate_timestamp!(mission["canceled_at"], "canceled_at", source)
      raise MissionError, "canceled mission has completed_at in #{source}" unless mission["completed_at"].nil?
    else
      raise MissionError, "active mission has completed_at in #{source}" unless mission["completed_at"].nil?
      raise MissionError, "active mission has canceled_at in #{source}" unless mission["canceled_at"].nil?
    end
    true
  end

  def validate_evidence!(entry, criterion_id, source)
    raise MissionError, "criterion #{criterion_id} evidence entry is invalid in #{source}" unless entry.is_a?(Hash)
    raise MissionError, "criterion #{criterion_id} evidence actor is blank in #{source}" if entry["actor"].to_s.strip.empty?
    validate_timestamp!(entry["recorded_at"], "evidence recorded_at", source)
    case entry["type"]
    when "command"
      raise MissionError, "criterion #{criterion_id} command evidence is invalid in #{source}" if entry["command"].to_s.empty? || entry["exit_code"] != 0
    when "attestation"
      raise MissionError, "criterion #{criterion_id} attestation is blank in #{source}" if entry["summary"].to_s.strip.empty?
    else
      raise MissionError, "criterion #{criterion_id} evidence type is invalid in #{source}"
    end
  end

  def validate_blocker!(blocker, source)
    raise MissionError, "mission blocker is invalid in #{source}" unless blocker.is_a?(Hash)
    raise MissionError, "mission blocker reason is blank in #{source}" if blocker["reason"].to_s.strip.empty?
    raise MissionError, "mission blocker actor is blank in #{source}" if blocker["actor"].to_s.strip.empty?
    validate_timestamp!(blocker["created_at"], "blocker created_at", source)
    return if blocker["resolved_at"].nil?
    validate_timestamp!(blocker["resolved_at"], "blocker resolved_at", source)
    raise MissionError, "resolved blocker has no actor in #{source}" if blocker["resolved_by"].to_s.strip.empty?
    raise MissionError, "resolved blocker has no resolution in #{source}" if blocker["resolution"].to_s.strip.empty?
  end

  def validate_note!(entry, source)
    raise MissionError, "mission note is invalid in #{source}" unless entry.is_a?(Hash)
    raise MissionError, "mission note is blank in #{source}" if entry["summary"].to_s.strip.empty?
    raise MissionError, "mission note actor is blank in #{source}" if entry["actor"].to_s.strip.empty?
    validate_timestamp!(entry["recorded_at"], "note recorded_at", source)
  end

  def validate_event!(event, source)
    raise MissionError, "mission event is invalid in #{source}" unless event.is_a?(Hash)
    raise MissionError, "mission event type is blank in #{source}" if event["type"].to_s.strip.empty?
    raise MissionError, "mission event actor is blank in #{source}" if event["actor"].to_s.strip.empty?
    validate_timestamp!(event["at"], "event at", source)
  end

  def validate_timestamp!(value, field, source)
    raise MissionError, "#{field} is invalid in #{source}" if value.to_s.empty?
    Time.iso8601(value)
  rescue ArgumentError
    raise MissionError, "#{field} is invalid in #{source}"
  end

  def persist(mission)
    FileUtils.mkdir_p(@missions_dir)
    validate_mission!(mission, mission.fetch("id"))
    atomic_write(mission_path(mission.fetch("id")), JSON.pretty_generate(public_state(mission)) + "\n")
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
    core_state(mission).merge("readiness" => readiness(mission), "next_action" => next_action(mission))
  end

  def core_state(mission)
    mission.reject { |key, _value| %w[readiness next_action].include?(key) }
  end

  def readiness(mission)
    total = mission.fetch("criteria").length
    satisfied = mission.fetch("criteria").count { |criterion| satisfied?(criterion) }
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
    return "Mission canceled." if mission.fetch("status") == "canceled"
    blocker = mission.fetch("blockers").find { |item| item["resolved_at"].nil? }
    return "Resolve blocker: #{blocker.fetch("reason")}" if blocker
    criterion = mission.fetch("criteria").find { |item| !satisfied?(item) }
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
    puts "Status: #{state.fetch("status").upcase}  |  Readiness: #{score.fetch("satisfied")}/#{score.fetch("total")} (#{score.fetch("percent")}%)  |  Revision: #{state.fetch("revision")}"
    puts ""
    puts "Acceptance criteria"
    state.fetch("criteria").each do |criterion|
      mark = satisfied?(criterion) ? "x" : " "
      puts "[#{mark}] #{criterion.fetch("id")}  #{criterion.fetch("text")}"
      criterion.fetch("evidence").each do |evidence|
        detail = evidence["summary"] || "#{evidence.fetch("command")} (exit #{evidence.fetch("exit_code")})"
        puts "    evidence: #{detail} — #{evidence.fetch("actor", "unknown")}"
      end
    end
    unresolved = state.fetch("blockers").select { |blocker| blocker["resolved_at"].nil? }
    unless unresolved.empty?
      puts ""
      puts "Blockers"
      unresolved.each { |blocker| puts "[!] #{blocker.fetch("reason")} — #{blocker.fetch("actor", "unknown")}" }
    end
    unless state.fetch("notes").empty?
      puts ""
      puts "Notes"
      state.fetch("notes").last(3).each { |entry| puts "- #{entry.fetch("summary")} — #{entry.fetch("actor")}" }
    end
    puts ""
    puts "Next: #{state.fetch("next_action")}"
    puts "State: #{mission_path(state.fetch("id"))}"
  end

  def criterion!(mission, identifier)
    criterion = mission.fetch("criteria").find { |item| item.fetch("id").casecmp?(identifier) }
    raise MissionError, "unknown criterion: #{identifier}" unless criterion
    criterion
  end

  def require_active!(mission)
    raise MissionError, "mission is blocked; resolve the blocker and run `orca mission resume`" if mission.fetch("status") == "blocked"
    raise MissionError, "mission is already completed" if mission.fetch("status") == "completed"
    raise MissionError, "mission is canceled; run `orca mission reopen #{mission.fetch("id")} --reason ...`" if mission.fetch("status") == "canceled"
  end

  def satisfied?(criterion)
    criterion.fetch("status") == "satisfied" && !criterion.fetch("evidence").empty?
  end

  def validate_criterion_texts!(texts)
    cleaned = texts.map { |text| text.to_s.strip }
    raise MissionError, "criteria cannot be blank" if cleaned.any?(&:empty?)
    raise MissionError, "criteria must be unique" unless cleaned.map(&:downcase).uniq.length == cleaned.length
  end

  def validate_identifier!(identifier)
    raise MissionError, "mission id is invalid: #{identifier}" unless identifier.to_s.match?(/\A[a-z0-9][a-z0-9-]{0,119}\z/)
  end

  def unique_id(outcome, timestamp)
    slug = slugify(outcome)
    slug = "mission" if slug.empty?
    base = "#{timestamp.delete("-:").sub("+0000", "").sub("Z", "").downcase}-#{slug}"
    candidate = base
    suffix = 2
    while File.exist?(mission_path(candidate))
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
    mission["revision"] = mission.fetch("revision", 0).to_i + 1
    mission.delete("readiness")
    mission.delete("next_action")
  end

  def now
    Time.now.utc.iso8601
  end

  def actor_name(value)
    actor = value.to_s.strip
    actor = ENV.fetch("ORCA_ACTOR", "").strip if actor.empty?
    actor = ENV.fetch("USER", "unknown").strip if actor.empty?
    raise MissionError, "actor cannot be blank" if actor.empty?
    actor
  end

  def take_option!(arguments, option)
    positions = arguments.each_index.select { |index| arguments[index] == option }
    raise MissionError, "#{option} may only be provided once" if positions.length > 1
    return nil if positions.empty?
    index = positions.first
    value = arguments[index + 1]
    raise MissionError, "#{option} requires a value" if value.to_s.empty? || value.start_with?("--")
    arguments.slice!(index, 2)
    value
  end

  def take_flag!(arguments, option)
    positions = arguments.each_index.select { |index| arguments[index] == option }
    raise MissionError, "#{option} may only be provided once" if positions.length > 1
    return false if positions.empty?
    arguments.delete_at(positions.first)
    true
  end

  def unique_option(existing, value, option)
    raise MissionError, "#{option} may only be provided once" unless existing.nil?
    value
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

  def optional_identifier(arguments, command)
    identifier = arguments.shift
    no_arguments!(arguments, command)
    identifier
  end

  def no_arguments!(arguments, command)
    raise MissionError, "#{command} does not accept arguments: #{arguments.join(" ")}" unless arguments.empty?
  end
end

exit OrcaMission.new(ARGV).run
