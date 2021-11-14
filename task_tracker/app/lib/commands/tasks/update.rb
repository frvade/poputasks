# frozen_string_literal: true

module Commands
  module Tasks
    class Update < Resol::Service
      param :task, SmartCore::Types::Protocol::InstanceOf(Task)
      param :task_params

      def call
        @task.assign_attributes(task_params)
        fail!(:invalid) unless validate_task
        fail!(:not_updated) unless task.save

        # CUD event
        task_attributes = task.attributes.slice(*%w[title jira_id description status])
        event = {
          event_name: 'TaskUpdated',
          event_version: 2,
          data: task_attributes.merge(public_id: task.public_id)
        }
        EventProducer.produce_sync(event, 'tasks.updated', 'tasks-stream')

        success!(task)
      end

      private

      def validate_task
        Validators::TaskValidator.call(task).success?
      end
    end
  end
end
