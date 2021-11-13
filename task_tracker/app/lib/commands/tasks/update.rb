# frozen_string_literal: true

module Commands
  module Tasks
    class Update < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)
      param :task_params

      def call
        fail!(:not_updated) unless task.update(task_params)

        # CUD event
        event = {
          event_name: 'TaskUpdated',
          data: task_params.to_h.merge(public_id: task.public_id)
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')

        success!(task)
      end
    end
  end
end
