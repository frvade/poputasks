# frozen_string_literal: true

module Commands
  module Tasks
    class Add < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)

      def call
        task.transaction do
          raise ActiveRecord::Rollback unless task.save

          assign_result = Commands::Tasks::Assign.call(task, task.assignee)
          raise ActiveRecord::Rollback if assign_result.failure?
        end

        fail!(:not_saved, { message: "Task wasn't saved", task: task }) unless task.persisted?

        event = {
          event_name: 'TaskCreated',
          data: task.to_json
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')
        success!(task)
      end
    end
  end
end
