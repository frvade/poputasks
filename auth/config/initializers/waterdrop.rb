# frozen_string_literal: true

class EventProducer
  class << self
    def produce_sync(event, event_type, topic)
      event = default_event_data.merge(event)
      return unless valid_event?(event, event_type)

      producer.produce_sync(payload: event.to_json, topic: topic)
    end

    private

    def valid_event?(event, event_type, event_version: nil)
      event_version ||= event.dig(:event_version)
      SchemaRegistry.validate_event(event, event_type, version: event_version).success?
    end

    def producer
      @producer ||= WaterDrop::Producer.new do |config|
        config.deliver = true
        config.logger = Rails.logger
        config.kafka = { 'bootstrap.servers': 'localhost:9092' }
      end
    end

    def default_event_data
      {
        event_id: SecureRandom.uuid,
        event_time: Time.now.to_s,
        producer: 'auth_service',
      }
    end
  end
end
