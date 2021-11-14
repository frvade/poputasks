# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |event|
      event_data = event['data']

      case event['event_name']
      when 'TaskCreated', 'TaskUpdated', 'TaskPriced'
        Task.upsert(event_data, unique_by: :public_id)
      when 'TaskCompleted'
        task_data = { public_id: event_data['public_id'], status: "completed", completed_at: event['event_time'] }
        Task.upsert(task_data, unique_by: :public_id)
      else
        # store events in DB
      end
    end
  end
end
