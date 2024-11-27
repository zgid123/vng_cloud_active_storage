# frozen_string_literal: true

require 'uri'
require 'net/http'

module VngStorageActiveStorage
  class RequestClient
    class << self
      def post(url:, body:, headers: nil)
        response = make_request(url, Net::HTTP::Post, body, headers)

        handle_response(response)
      end

      private

      def make_request(url, method_class, body, headers)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = method_class.new(
          uri.path,
          headers || { 'Content-Type' => 'application/json' }
        )

        request.body = body.to_json unless method_class.is_a?(Net::HTTP::Get)

        http.request(request)
      end

      def handle_response(response)
        raise JSON.parse(response.body).with_indifferent_access[:errors].first[:message] unless success?(response) # handle error in vstorage_service

        JSON.parse(response.body).with_indifferent_access
      end

      def success?(response)
        code = response.code.to_i

        code >= 200 && code < 300
      end
    end
  end
end
