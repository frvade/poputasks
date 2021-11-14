# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  api_id = ENV['ACCOUNTS_API_ID'] || 'cQRKA9ap5CwE6jlqmX6tCH8OvfAkW5LCM31x6HV2TUU'
  api_secret = ENV['ACCOUNTS_API_SECRET'] || 'FdlRhImneuyVaLPOWGfhAV_9fUZx2XjKMiAkZde3ArY'
  provider :popug, api_id, api_secret, scope: 'public write'
end

OmniAuth.config.logger = Rails.logger
