# frozen_string_literal: true

class EventProducer
  def self.produce_sync(payload:, topic:)
    WaterDrop::SyncProducer.call(payload, topic: topic)
  end
end
