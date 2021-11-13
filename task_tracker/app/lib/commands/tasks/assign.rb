# frozen_string_literal: true

module Commands
  module Tasks
    class Assign < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)
      param :assignee, SmartCore::Types::Protocol::InstanceOf(User)

      def call
        fail!(:not_assigned) unless task.update(assignee: assignee)

        # CUD event
        event = {
          event_name: 'TaskUpdated',
          data: { public_id: task.public_id, assignee_id: assignee.public_id }
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')

        # Business event
        event = {
          event_name: 'TaskAssigned',
          data: { public_id: task.public_id, assignee_id: assignee.public_id }
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-lifecycle')

        success!(task)
      end
    end
  end
end
