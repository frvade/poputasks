# frozen_string_literal: true

class EventProducer
  class << self
    def call(event, **payload)
      puts "Produce: #{event.inspect}"
    end
  end
end
