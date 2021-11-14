# frozen_string_literal: true

module Commands
  module Tasks
    class Assign < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)
      param :assignee, SmartCore::Types::Protocol::InstanceOf(User)

      def call
        task.assignee = assignee
        fail!(:not_assigned) unless task.save

        # Business event
        event = {
          event_name: 'TaskAssigned',
          event_version: 1,
          data: { public_id: task.public_id, assignee: { public_id: assignee.public_id } }
        }
        EventProducer.produce_sync(event, 'tasks.assigned', 'tasks-lifecycle')

        success!(task)
      end
    end
  end
end
