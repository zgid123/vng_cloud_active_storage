# frozen_string_literal: true

require 'base64'
require 'active_storage/service/s3_service'

module ActiveStorage
  class Service
    class VstorageService < S3Service
      attr_reader :region,
                  :client_id,
                  :project_id,
                  :client_secret,
                  :authorization

      def initialize(bucket:, upload: {}, public: false, **options)
        @region = options[:region].downcase
        @project_id = upload.delete(:project_id)
        @client_id = upload.delete(:client_id)
        @client_secret = upload.delete(:client_secret)
        @authorization = Base64.strict_encode64("#{@client_id}:#{@client_secret}")

        super(bucket: bucket, upload: upload, public: public, **options)
      end

      def url_for_direct_upload(key, expires_in:, **)
        instrument(:url, key: key) do |payload|
          generated_url = temp_url(bucket, key, expires_in)
          payload[:url] = generated_url
          generated_url
        end
      end

      private

      def public_url(key, **)
        "https://#{region}.vstorage.vngcloud.vn/v1/AUTH_#{project_id}/#{bucket.name}/#{key}"
      end

      def temp_url(bucket, key, expires_in)
        response = VngStorageActiveStorage::RequestClient.post(
          url: "https://#{region}-api.vstorage.vngcloud.vn/api/v1/projects/#{project_id}/containers/#{bucket.name}/objects/#{key}/upload_tempurls",
          body: {
            timeExpire: expires_in.to_i
          },
          headers: {
            'Content-Type': 'application/json',
            Authorization: "Bearer #{access_token}"
          }
        )

        response[:data][key]
      rescue StandardError => e
        raise VngStorageActiveStorage::Error, "Request temp url failed with error: #{e.message}"
      end

      def access_token
        Rails.cache.fetch("vstorage_access_token_#{project_id}", expires_in: 15.minutes) do
          response = VngStorageActiveStorage::RequestClient.post(
            url: 'https://iamapis.vngcloud.vn/accounts-api/v2/auth/token',
            body: {
              scope: 'email',
              grant_type: 'client_credentials'
            },
            headers: {
              'Content-Type': 'application/json',
              Authorization: "Basic #{authorization}"
            }
          )

          response[:access_token]
        end
      rescue StandardError => e
        raise VngStorageActiveStorage::Error, "Request Access Token failed with error: #{e.message}"
      end
    end
  end
end
