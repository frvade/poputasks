# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  api_id = ENV['ACCOUNTS_API_ID'] || 'K52_NQnquYGfeXVwfI8PSZPp5Rv2zu1OPzkhixpLniw'
  api_secret = ENV['ACCOUNTS_API_SECRET'] || 'frSXNI6t6UEHF_1RPylgBMSyer-mY9fg3lAIX-N5IAg'
  provider :popug, api_id, api_secret, scope: 'public write'
end

OmniAuth.config.logger = Rails.logger
