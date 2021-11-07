# frozen_string_literal: true

class EventProducer
  class << self
    def call(event, **payload)
      WaterDrop::SyncProducer.call(event, payload)
    end
  end
end
