# frozen_string_literal: true

module Commands
  module Tasks
    class Complete < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)
      option :actor, SmartCore::Types::Protocol::InstanceOf(User)

      def call
        fail!(:forbidden) unless task.assignee == actor || actor.admin?
        task.completed!

        # CUD event
        event = {
          event_name: 'TaskUpdated',
          data: task.to_json
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')

        # Business event
        event = {
          event_name: 'TaskCompleted',
          data: { public_id: task.public_id, status: task.status }
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks')

        success!(task)
      end
    end
  end
end
