require "savon/log_message"

module Savon
  class RequestLogger

    def initialize(globals)
      @globals = globals
    end

    def log(request, &http_request)
      log_request(request) if log?
      response = http_request.call
      log_response(response) if log?

      response
    end

    def logger
      @globals[:logger]
    end

    def log?
      @globals[:log]
    end

    private

    def log_request(request)
      logger.send @globals[:log_level], "SOAP request: #{request.url}"
      logger.send @globals[:log_level], headers_to_log(request.headers)
      logger.send @globals[:log_level], body_to_log(request.body)
    end

    def log_response(response)
      logger.send @globals[:log_level], "SOAP response (status #{response.code})"
      logger.send @globals[:log_level],  body_to_log(response.body)
    end

    def headers_to_log(headers)
      headers.map { |key, value| "#{key}: #{value}" }.join(", ")
    end

    def body_to_log(body)
      LogMessage.new(body, @globals[:filters], @globals[:pretty_print_xml]).to_s
    end

  end
end
