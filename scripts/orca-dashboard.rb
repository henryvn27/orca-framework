#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "rbconfig"
require "securerandom"
require "socket"
require "uri"

class DashboardError < StandardError; end
class DashboardAuthError < DashboardError; end

class OrcaDashboard
  Request = Struct.new(:method, :path, :query, :headers, :body)
  Response = Struct.new(:status, :headers, :body)

  MAX_BODY_BYTES = 64 * 1024
  MAX_HEADER_BYTES = 32 * 1024
  MAX_LINE_BYTES = 8 * 1024
  READ_TIMEOUT_SECONDS = 5
  ACTIONS = %w[create add reset check satisfy note block resume cancel reopen complete].freeze
  STATUS_TEXT = {
    200 => "OK",
    204 => "No Content",
    400 => "Bad Request",
    403 => "Forbidden",
    404 => "Not Found",
    422 => "Unprocessable Content",
    500 => "Internal Server Error"
  }.freeze

  def initialize(arguments)
    @arguments = arguments.dup
    @root = File.expand_path("..", __dir__)
    @project = Dir.pwd
    @port = 4242
    @open_browser = true
    @token = ENV.fetch("ORCA_DASHBOARD_TOKEN", SecureRandom.hex(32))
    @running = true
    parse_arguments!
    @orca_root = File.expand_path(ENV.fetch("ORCA_ROOT", File.join(@project, ".orca")))
    @assets = File.join(@root, "dashboard")
  end

  def run
    verify_runtime!
    @server = TCPServer.new("127.0.0.1", @port)
    actual_port = @server.addr.fetch(1)
    @origin = "http://127.0.0.1:#{actual_port}"
    install_signal_handlers
    puts "Orca Mission Control: #{@origin}"
    puts "Project: #{@project}"
    puts "State: #{@orca_root}"
    $stdout.flush
    launch_browser(@origin) if @open_browser
    serve
    0
  rescue DashboardError, SystemCallError => error
    warn "orca dashboard: #{error.message}"
    2
  ensure
    @server.close if defined?(@server) && @server && !@server.closed?
  end

  private

  def parse_arguments!
    until @arguments.empty?
      argument = @arguments.shift
      case argument
      when "--project"
        @project = File.expand_path(required_value("--project"))
      when "--port"
        value = required_value("--port")
        raise DashboardError, "--port must be an integer from 0 to 65535" unless value.match?(/\A\d+\z/)
        @port = value.to_i
        raise DashboardError, "--port must be an integer from 0 to 65535" unless @port.between?(0, 65_535)
      when "--no-open"
        @open_browser = false
      when "-h", "--help"
        puts "Usage: orca dashboard [--project PATH] [--port PORT] [--no-open]"
        exit 0
      else
        raise DashboardError, "unknown option: #{argument}"
      end
    end
  end

  def required_value(option)
    value = @arguments.shift
    raise DashboardError, "#{option} requires a value" if value.to_s.empty? || value.start_with?("--")
    value
  end

  def verify_runtime!
    raise DashboardError, "project directory does not exist: #{@project}" unless Dir.exist?(@project)
    raise DashboardError, "dashboard assets are missing: #{@assets}" unless Dir.exist?(@assets)
    runtime = File.join(@root, "scripts", "orca-mission.rb")
    raise DashboardError, "mission runtime is missing: #{runtime}" unless File.file?(runtime)
  end

  def install_signal_handlers
    %w[INT TERM].each do |signal|
      trap(signal) do
        @running = false
        @server.close if @server && !@server.closed?
      rescue IOError, SystemCallError
        nil
      end
    rescue ArgumentError
      nil
    end
  end

  def serve
    while @running
      begin
        client = @server.accept
        handle_connection(client)
      rescue IOError, Errno::EBADF
        break unless @running
        raise
      rescue SystemCallError => error
        break unless @running
        warn "orca dashboard: #{error.message}"
      end
    end
  end

  def handle_connection(client)
    request = parse_request(client)
    response = Response.new(200, {}, "")
    route(request, response)
    write_response(client, response)
  rescue DashboardError => error
    response = Response.new(400, {}, "")
    secure_headers(response)
    json_response(response, 400, { ok: false, error: error.message })
    write_response(client, response)
  rescue StandardError => error
    warn "orca dashboard: #{error.class}: #{error.message}"
    response = Response.new(500, {}, "")
    secure_headers(response)
    json_response(response, 500, { ok: false, error: "Mission Control could not complete the request" })
    write_response(client, response)
  ensure
    client.close if client && !client.closed?
  end

  def parse_request(client)
    request_line = timed_gets(client)
    raise DashboardError, "Empty HTTP request" if request_line.nil?
    method, target, version = request_line.strip.split(" ", 3)
    unless %w[GET POST].include?(method) && target&.start_with?("/") && version&.start_with?("HTTP/1.")
      raise DashboardError, "Unsupported HTTP request"
    end

    headers = {}
    header_bytes = request_line.bytesize
    loop do
      line = timed_gets(client)
      raise DashboardError, "Incomplete HTTP headers" if line.nil?
      header_bytes += line.bytesize
      raise DashboardError, "HTTP headers are too large" if header_bytes > MAX_HEADER_BYTES
      break if line == "\r\n" || line == "\n"
      name, value = line.split(":", 2)
      raise DashboardError, "Malformed HTTP header" if value.nil? || name.to_s.empty?
      key = name.strip.downcase
      raise DashboardError, "Duplicate HTTP header: #{key}" if headers.key?(key)
      headers[key] = value.strip
    end

    content_length = Integer(headers.fetch("content-length", "0"), 10)
    raise DashboardError, "Content-Length cannot be negative" if content_length.negative?
    raise DashboardError, "Request body is too large" if content_length > MAX_BODY_BYTES
    body = read_exact(client, content_length)
    path, query_string = target.split("?", 2)
    query = query_string ? URI.decode_www_form(query_string).to_h : {}
    Request.new(method, path, query, headers, body)
  rescue ArgumentError
    raise DashboardError, "Content-Length must be an integer"
  end

  def timed_gets(client)
    ready = IO.select([client], nil, nil, READ_TIMEOUT_SECONDS)
    raise DashboardError, "HTTP request timed out" unless ready
    client.gets("\n", MAX_LINE_BYTES)
  end

  def read_exact(client, length)
    body = +""
    while body.bytesize < length
      ready = IO.select([client], nil, nil, READ_TIMEOUT_SECONDS)
      raise DashboardError, "HTTP request body timed out" unless ready
      body << client.readpartial([16 * 1024, length - body.bytesize].min)
    end
    body
  rescue EOFError
    raise DashboardError, "HTTP request body ended early"
  end

  def write_response(client, response)
    body = response.body.to_s
    body = "" if response.status == 204
    response.headers["Content-Length"] = body.bytesize.to_s
    response.headers["Connection"] = "close"
    status_text = STATUS_TEXT.fetch(response.status, "Response")
    client.write("HTTP/1.1 #{response.status} #{status_text}\r\n")
    response.headers.each { |name, value| client.write("#{name}: #{value}\r\n") }
    client.write("\r\n")
    client.write(body) unless body.empty?
  rescue Errno::EPIPE, Errno::ECONNRESET, IOError
    nil
  end

  def route(request, response)
    secure_headers(response)
    case [request.method, request.path]
    when ["GET", "/"]
      serve_index(response)
    when ["GET", "/orca.css"]
      serve_asset(response, "orca.css", "text/css; charset=utf-8")
    when ["GET", "/orca.js"]
      serve_asset(response, "orca.js", "text/javascript; charset=utf-8")
    when ["GET", "/favicon.ico"]
      response.status = 204
      response.body = ""
    when ["GET", "/api/state"]
      serve_state(request, response)
    when ["POST", "/api/action"]
      authorize_mutation!(request)
      serve_action(request, response)
    else
      json_response(response, 404, { ok: false, error: "Not found" })
    end
  rescue DashboardAuthError => error
    json_response(response, 403, { ok: false, error: error.message })
  rescue DashboardError => error
    json_response(response, error.message == "Not found" ? 404 : 422, { ok: false, error: error.message })
  rescue JSON::ParserError
    json_response(response, 400, { ok: false, error: "Request body must be valid JSON" })
  rescue StandardError => error
    warn "orca dashboard: #{error.class}: #{error.message}"
    json_response(response, 500, { ok: false, error: "Mission Control could not complete the request" })
  end

  def secure_headers(response)
    response.headers["Cache-Control"] = "no-store"
    response.headers["Content-Security-Policy"] = "default-src 'self'; connect-src 'self'; img-src 'self' data:; style-src 'self'; script-src 'self'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'"
    response.headers["Referrer-Policy"] = "no-referrer"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
  end

  def serve_index(response)
    template = File.read(File.join(@assets, "index.html"))
    response.status = 200
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    response.body = template.sub("{{ORCA_SESSION_TOKEN}}", @token)
  end

  def serve_asset(response, filename, content_type)
    path = File.join(@assets, filename)
    raise DashboardError, "Not found" unless File.file?(path)
    response.status = 200
    response.headers["Content-Type"] = content_type
    response.body = File.binread(path)
  end

  def serve_state(request, response)
    list = mission_command(["list", "--json"])
    missions = list.fetch("missions")
    selected = request.query["mission"]
    selected = missions.find { |mission| mission.fetch("active") }&.fetch("id") if selected.to_s.empty?
    selected = missions.last&.fetch("id") if selected.to_s.empty?
    current = selected ? mission_command(["show", selected, "--json"]).fetch("mission") : nil
    json_response(response, 200, { ok: true, project: @project, state_root: @orca_root, missions: missions.reverse, current: current })
  end

  def serve_action(request, response)
    payload = JSON.parse(request.body.to_s)
    raise DashboardError, "Request body must be a JSON object" unless payload.is_a?(Hash)
    action = payload["action"].to_s
    raise DashboardError, "Unsupported action: #{action}" unless ACTIONS.include?(action)
    arguments = action_arguments(action, payload)
    separator = arguments.index("--")
    separator ? arguments.insert(separator, "--json") : arguments << "--json"
    json_response(response, 200, mission_command(arguments))
  end

  def authorize_mutation!(request)
    unless secure_compare(request.headers.fetch("x-orca-token", ""), @token)
      raise DashboardAuthError, "Mission Control session token is missing or invalid"
    end
    raise DashboardAuthError, "Mission Control rejected a cross-origin request" unless request.headers.fetch("origin", "") == @origin
    content_type = request.headers.fetch("content-type", "")
    raise DashboardError, "Content-Type must be application/json" unless content_type.start_with?("application/json")
  end

  def secure_compare(left, right)
    return false unless left.bytesize == right.bytesize
    left.bytes.zip(right.bytes).reduce(0) { |difference, pair| difference | (pair[0] ^ pair[1]) }.zero?
  end

  def action_arguments(action, payload)
    actor = optional_text(payload, "actor", "Mission Control")
    case action
    when "create"
      outcome = required_text(payload, "outcome")
      criteria = payload["criteria"]
      raise DashboardError, "criteria must contain at least one item" unless criteria.is_a?(Array) && !criteria.empty?
      values = criteria.map { |criterion| criterion.to_s.strip }
      raise DashboardError, "criteria cannot be blank" if values.any?(&:empty?)
      ["create", outcome, *values.flat_map { |criterion| ["--criterion", criterion] }, "--by", actor]
    when "add"
      ["add", "--criterion", required_text(payload, "criterion"), "--by", actor]
    when "reset"
      ["reset", required_text(payload, "criterion_id"), "--reason", required_text(payload, "reason"), "--by", actor]
    when "check"
      command = payload["command"]
      raise DashboardError, "command must contain an executable and arguments" unless command.is_a?(Array) && !command.empty?
      command = command.map(&:to_s)
      raise DashboardError, "command arguments cannot contain null bytes" if command.any? { |part| part.include?("\0") }
      ["check", required_text(payload, "criterion_id"), "--by", actor, "--", *command]
    when "satisfy"
      ["satisfy", required_text(payload, "criterion_id"), "--evidence", required_text(payload, "evidence"), "--by", actor]
    when "note"
      ["note", required_text(payload, "summary"), "--by", actor]
    when "block"
      ["block", required_text(payload, "reason"), "--by", actor]
    when "resume"
      ["resume", "--reason", optional_text(payload, "reason", "Blocker resolved in Mission Control"), "--by", actor]
    when "cancel"
      ["cancel", required_text(payload, "reason"), "--by", actor]
    when "reopen"
      ["reopen", required_text(payload, "mission_id"), "--reason", required_text(payload, "reason"), "--by", actor]
    when "complete"
      ["complete", "--by", actor]
    else
      raise DashboardError, "Unsupported action: #{action}"
    end
  end

  def required_text(payload, key)
    value = payload[key].to_s.strip
    raise DashboardError, "#{key.tr('_', ' ')} is required" if value.empty?
    value
  end

  def optional_text(payload, key, fallback)
    value = payload[key].to_s.strip
    value.empty? ? fallback : value
  end

  def mission_command(arguments)
    runtime = File.join(@root, "scripts", "orca-mission.rb")
    environment = { "ORCA_ROOT" => @orca_root, "RUBYOPT" => [ENV["RUBYOPT"], "--disable-gems"].compact.join(" ") }
    stdout, stderr, status = Open3.capture3(environment, RbConfig.ruby, runtime, *arguments, chdir: @project)
    payload = JSON.parse(stdout)
    unless status.success? && payload["ok"]
      raise DashboardError, payload["error"] || stderr.strip || "Mission command failed"
    end
    payload
  rescue JSON::ParserError
    raise DashboardError, stderr.to_s.strip.empty? ? "Mission runtime returned invalid output" : stderr.to_s.strip
  end

  def json_response(response, status, payload)
    response.status = status
    response.headers["Content-Type"] = "application/json; charset=utf-8"
    response.body = JSON.generate(payload)
  end

  def launch_browser(url)
    command = if RUBY_PLATFORM.include?("darwin")
                ["open", url]
              elsif RUBY_PLATFORM.match?(/mingw|mswin/)
                ["cmd", "/c", "start", "", url]
              else
                ["xdg-open", url]
              end
    Process.spawn(*command, out: File::NULL, err: File::NULL)
  rescue Errno::ENOENT, SystemCallError
    warn "orca dashboard: browser could not be opened automatically; visit #{url}"
  end
end

exit OrcaDashboard.new(ARGV).run
