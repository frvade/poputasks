# frozen_string_literal: true

class EventProducer
  class << self
    def produce_sync(event, event_type, topic)
      event = default_event_data.merge(event)
      return unless valid_event?(event, event_type)

      WaterDrop::SyncProducer.call(event.to_json, topic: topic)
    end

    private

    def valid_event?(event, event_type)
      SchemaRegistry.validate_event(event, event_type, version: event.dig(:event_version)).success?
    end

    def default_event_data
      {
        event_id: SecureRandom.uuid,
        event_time: Time.now.to_s,
        producer: 'accounting_service',
      }
    end
  end
end
