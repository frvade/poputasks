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
        event = {
          event_name: 'TaskUpdated',
          data: task_params.to_h.merge(public_id: task.public_id)
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'tasks-stream')

        success!(task)
      end

      private

      def validate_task
        Validators::TaskValidator.call(task).success?
      end
    end
  end
end
