# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |event|
      event_data = event['data']

      case event['event_name']
      when 'TaskCreated', 'TaskUpdated'
        Task.upsert(event_data, unique_by: :public_id)
      when 'TaskCompleted'
        Task.upsert({ public_id: event_data['public_id'], status: "completed" }, unique_by: :public_id)
      else
        # store events in DB
      end
    end
  end
end
