require 'projectvinyl/web/ajax'

module Mojang
  module Auth
    class Yggdrasil
      PROTOCOL = 'https'.freeze
      SERVER = 'authserver.mojang.com'.freeze
      
      def self.send_request(endpoint, identify_self, params)
        if identify_self
          params[:clientToken] = Rails.application.secrets.yggdrasil_pub_key
        end
        
        ProjectVinyl::Web::Ajax.new("#{PROTOCOL}://#{SERVER}/#{endpoint}").post(params.to_json, {
          'Content-Type' => 'application/json'
        }) do |response|
          if !response.nil?
            response = JSON.parse(response)
            
            yield(response['accessToken'], response['selectedProfile'])
          else
            yield
          end
        end
      end
      
      #
      # Auth Endpoints
      #
      
      # 
      # Authenticates a username and password.
      #
      # parameters:
      #   username - displayName or email address
      #   pass     - account password
      # 
      # clientToken: required
      #
      def self.authenticate(user, pass)
        Yggdrasil.send_request(:authenticate, true, {
          agent: { name: "Minecraft", version: 1 },
          username: user,
          password: pass,
          requestUser: true
        }) do |new_access_token, profile|
          yield(new_access_token, profile)
        end
      end
      
      #
      # Checks that an access token is still validate
      #
      # parameters:
      #   access_token - the token to validate
      #   identify_self (true) - whether to include a client token with the request
      #
      # clientToken: optional
      #
      def self.validate(access_token, identify_self = true)
        Yggdrasil.send_request(:validate, identify_self, accessToken: access_token) do
          yield(access_token) if block_given?
        end
      end
      
      #
      # Refreshes a valid token.
      # The provided token is invalidated and replaced by the returned one.
      # Note: Provided token is invalidated
      #
      # parameters:
      #   access_token - the token to replace
      #
      # clientToken: required
      #
      def self.refresh(access_token)
        Yggdrasil.send_request(:refresh, true, {
          accessToken: access_Token,
          requestUser: true
        }) do |new_access_token, profile|
          yield(new_access_token, profile)
        end
      end
      
      #
      # Deletes a valid access token
      #
      # parameters:
      #   access_token - the token to invalidate
      #
      # clientToken: required
      #
      def self.invalidate(access_token)
        Yggdrasil.send_request(:invalidate, true, accessToken: access_token) do
          yield
        end
      end
    end
  end
end