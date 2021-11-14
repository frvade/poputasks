# frozen_string_literal: true

module OmniAuth
  module Strategies
    class Popug < OmniAuth::Strategies::OAuth2
      option :name, :popug

      option :client_options, {
        site: 'http://127.0.0.1:3000/oauth/authorize',
        authorize_url: 'http://127.0.0.1:3000/oauth/authorize'
      }

      uid { raw_info['public_id'] }

      info do
        {
          email: raw_info['email'],
          name: raw_info['name'],
          active: raw_info['active'],
          role: raw_info['role'],
          public_id: raw_info['public_id'],
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/users/current').parsed
      end
    end
  end
end
