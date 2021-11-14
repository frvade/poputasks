# frozen_string_literal: true

module Commands
  module Tasks
    class Add < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)

      def call
        fail!(:invalid) unless validate_task
        task.save or fail!(:not_saved, { message: "Task wasn't saved", task: task })

        event = {
          event_name: 'TaskCreated',
          event_version: 2,
          data: task.reload.attributes.slice(*%w[title description jira_id, public_id status])
        }
        EventProducer.produce_sync(event, 'tasks.created', 'tasks-stream')

        Commands::Tasks::Assign.call!(task, task.assignee)

        success!(task)
      end

      private

      def validate_task
        Validators::TaskValidator.call(task).success?
      end
    end
  end
end
