# frozen_string_literal: true

module Commands
  module Tasks
    class Add < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)

      def call
        task.save or fail!(:not_saved, { message: "Task wasn't saved", task: task })

        event = {
          event_name: 'TaskCreated',
          data: task.to_h
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')

        Commands::Tasks::Assign.call!(task, task.assignee)

        event = {
          event_name: 'TaskAdded',
          data: {
            title: task.title,
            description: task.description,
            public_id: task.public_id,
            assignee_id: task.assignee_id,
          }
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-lifecycle')

        success!(task)
      end
    end
  end
end
