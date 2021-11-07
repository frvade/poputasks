# frozen_string_literal: true

EventProducer = WaterDrop::Producer.new do |config|
  config.deliver = true
  config.logger = Rails.logger
  config.kafka = { 'bootstrap.servers': 'localhost:9092' }
end
