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
          event_version: 2,
          data: { public_id: task.public_id, status: task.status }
        }
        EventProducer.produce_sync(event, 'tasks.updated', 'tasks-stream')

        # Business event
        event = {
          event_name: 'TaskCompleted',
          event_version: 1,
          data: { public_id: task.public_id }
        }
        EventProducer.produce_sync(event, 'tasks.completed', 'tasks-lifecycle')

        success!(task)
      end
    end
  end
end
