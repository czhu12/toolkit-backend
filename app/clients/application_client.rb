class ApplicationClient
  # A basic API client with HTTP methods
  #
  # The Authorization Bearer token header for authentication is included by default
  # You can override the `authorization_header` method to change this
  #
  # Content Type is application/json by default
  # You can override the `content_type` to
  #
  # An example API client:
  #
  #   class DigitalOceanClient < ApplicationClient
  #     BASE_URI = "https://api.digitalocean.com/v2"
  #
  #     def account
  #       get("/account").account
  #     rescue *NET_HTTP_ERRORS
  #       raise Error, "Unable to load your account"
  #     end
  #   end

  # Common HTTP Errors
  # See `handle_response` to add more error types as needed
  class Error < StandardError; end

  class Forbidden < Error; end

  class Unauthorized < Error; end

  class RateLimit < Error; end

  class NotFound < Error; end

  class InternalError < Error; end

  BASE_URI = "https://example.org"
  NET_HTTP_ERRORS = [Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError]

  attr_reader :token

  # Override if API requires additional attributes
  def initialize(token:)
    @token = token
  end

  # Override to customize default headers
  # Content-Type will be removed on GET requests
  # Returns a Hash
  def default_headers
    {
      "Accept" => content_type,
      "Content-Type" => content_type
    }.merge(authorization_header)
  end

  # Override to customize the content type
  # Returns a String
  def content_type
    "application/json"
  end

  # Override to customize the authorization header
  # Returns a Hash
  #
  # Examples:
  #
  #   { "X-API-Key" => token }
  #   { "AccessKey" => token }
  def authorization_header
    {"Authorization" => "Bearer #{token}"}
  end

  # Override to customize default query params
  # Returns a Hash
  def default_query_params
    {}
  end

  # Make a GET request
  # Pass `headers: {}` to add or override default headers
  # Pass `query: {}` to add query parameters
  #
  #   get("/tweets/1")
  #   => GET /tweets/1
  #
  #   get("/tweets/1", query: {foo: :bar})
  #   => GET /tweets/1?foo=bar
  #
  #  get("/tweets/1", headers: {"Content-Type" => "application/xml")
  #  => GET /tweets/1
  #  => Content-Type: application/xml
  def get(path, headers: {}, query: nil)
    make_request(klass: Net::HTTP::Get, path: path, headers: headers, query: query)
  end

  # Make a POST request
  # Pass `headers: {}` to add or override default headers
  # Pass `query: {}` to add query parameters
  # Pass `body: {}` to add a body to the request
  def post(path, headers: {}, query: nil, body: nil)
    make_request(klass: Net::HTTP::Post, path: path, headers: headers, query: query, body: body)
  end

  # Make a PATCH request
  # Pass `headers: {}` to add or override default headers
  # Pass `query: {}` to add query parameters
  # Pass `body: {}` to add a body to the request
  def patch(path, headers: {}, query: nil, body: nil)
    make_request(klass: Net::HTTP::Patch, path: path, headers: headers, query: query, body: body)
  end

  # Make a PUT request
  # Pass `headers: {}` to add or override default headers
  # Pass `query: {}` to add query parameters
  # Pass `body: {}` to add a body to the request
  def put(path, headers: {}, query: nil, body: nil)
    make_request(klass: Net::HTTP::Put, path: path, headers: headers, query: query, body: body)
  end

  # Make a DELETE request
  # Pass `headers: {}` to add or override default headers
  # Pass `query: {}` to add query parameters
  # Pass `body: {}` to add a body to the request
  def delete(path, headers: {}, query: nil, body: nil)
    make_request(klass: Net::HTTP::Delete, path: path, headers: headers, query: query, body: body)
  end

  # Returns the BASE_URI from the current class
  def base_uri
    self.class::BASE_URI
  end

  # Makes an HTTP request
  #   `klass` should be a Net::HTTP::Request class such as Net::HTTP::Get
  #   `path` is a String for the URL path without the protocol and domain. For example: "/api/v1/me"
  #   `headers:` is a Hash of HTTP headers
  #   `body:` can be a string, Hash, or any other object that can be serialized to a string
  #   `query:` is hash of query parameters to append to the path. For example: {foo: :bar} will add "?foo=bar" to the URL path
  def make_request(klass:, path:, headers: {}, body: nil, query: nil)
    uri = URI("#{base_uri}#{path}")

    # Merge query params with any currently in `path`
    existing_params = Rack::Utils.parse_query(uri.query).with_defaults(default_query_params)
    query_params = existing_params.merge(query || {})
    uri.query = Rack::Utils.build_query(query_params) if query_params.present?

    Rails.logger.debug("#{klass.name.split("::").last.upcase}: #{uri}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS

    all_headers = default_headers.merge(headers)

    # Remove Content-Type if there is no body
    all_headers.delete("Content-Type") if klass == Net::HTTP::Get

    request = klass.new(uri.request_uri, all_headers)
    request.body = build_body(body) if body.present?

    handle_response Response.new(http.request(request))
  end

  # Handles an HTTP response
  # - Parse the response code
  # - Raise an error if not 20X
  # - If response body, parses and returns
  # - Otherwise returns nil
  def handle_response(response)
    case response.code
    when "200", "201", "202", "203", "204"
      response
    when "401"
      raise Unauthorized, response.body
    when "403"
      raise Forbidden, response.body
    when "404"
      raise NotFound, response.body
    when "429"
      raise RateLimit, response.body
    when "500"
      raise InternalError, response.body
    else
      raise Error, "#{response.code} - #{response.body}"
    end
  end

  # Converts a body to the matching ContentType
  # Override this to convert request bodies to other content types
  def build_body(body)
    case body
    when String
      body
    else
      body.to_json
    end
  end

  class Response
    # Provides easy access to the parsed response body as well as the response object headers and status code
    #
    # To add customer content type parser, register it in the PARSER hash
    # ApplicationClient::Response::PARSER["text/html"] = ->(response) { Nokogiri::HTML(response.body) }
    #
    # To parse JSON as a Hash instead of OpenStruct
    # ApplicationClient::Response::JSON_OBJECT_CLASS = nil

    JSON_OBJECT_CLASS = OpenStruct
    PARSER = {
      "application/json" => ->(response) { JSON.parse(response.body, object_class: JSON_OBJECT_CLASS) },
      "application/xml" => ->(response) { Nokogiri::XML(response.body) }
    }
    FALLBACK_PARSER = ->(response) { response.body }

    attr_reader :original_response

    delegate :code, :body, to: :original_response
    delegate_missing_to :parsed_body

    def initialize(original_response)
      @original_response = original_response
    end

    # Returns a hash of headers with underscored names as symbols
    def headers
      @headers ||= original_response.each_header.to_h.transform_keys { |k| k.underscore.to_sym }
    end

    def content_type
      headers[:content_type]
    end

    def parsed_body
      @parsed_body ||= PARSER.fetch(content_type, FALLBACK_PARSER).call(self)
    end
  end
end
