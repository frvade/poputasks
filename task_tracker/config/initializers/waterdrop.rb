# frozen_string_literal: true

WaterDrop.setup do |config|
  config.deliver = true
  config.logger = Rails.logger
  config.kafka.seed_brokers = %w[kafka://localhost:9092]
end
