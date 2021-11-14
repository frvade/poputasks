# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  api_id = ENV['ACCOUNTS_API_ID'] || '_h2ToimoQXZVNwJXbN2bHpVYmOFUPfcjseVfpSbI8Sg'
  api_secret = ENV['ACCOUNTS_API_SECRET'] || 'zplF1nM7wUTqWrCayOQe4JgD-CKVytwe-MMHpXhlOYY'
  provider :popug, api_id, api_secret, scope: 'public write'
end

OmniAuth.config.logger = Rails.logger
