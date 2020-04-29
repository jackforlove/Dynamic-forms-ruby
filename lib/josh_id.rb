require 'omniauth-oauth2'
require "./app/models/setting"
module OmniAuth
  module Strategies
    class JoshId < OmniAuth::Strategies::OAuth2
      option :client_options, {
          :site =>  Setting.sso_host,
          :authorize_url => "#{Setting.sso_host}/auth/josh_id/authorize",
          :access_token_url => "#{Setting.sso_host}/auth/josh_id/access_token"
      }

      uid { raw_info['id'] }

      info do
        {
            :login => raw_info['extra']['login']
        }
      end

      extra do
        {
            :name => raw_info['extra']['name'],
            :login => raw_info['extra']['login'],
            :description  => raw_info['extra']['description'],
            :school_id  => raw_info['extra']['school_id'], #deprecated
            :school_ids => raw_info['extra']['school_ids'],
            :available  => raw_info['extra']['available'],
            :type_id  => raw_info['extra']['type_id'],
            :gender  => raw_info['extra']['gender'],
            :avatar  => raw_info['extra']['avatar_url'],
            :session_token  => raw_info['extra']['session_token']
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/auth/josh_id/user.json?oauth_token=#{access_token.token}").parsed
      end
    end
  end
end