# frozen_string_literal: true

module Commands
  module Tasks
    class Price < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)

      def call
        price = calculate_price
        task.update(price: price) or fail!(:not_updated)

        event = {
          event_name: 'TaskPriced',
          event_version: 1,
          data: { public_id: task.public_id, price: price }
        }
        EventProducer.produce_sync(event, 'tasks.priced', 'tasks-lifecycle')

        success!(task)
      end

      private

      def calculate_price
        rand(10..20)
      end
    end
  end
end
