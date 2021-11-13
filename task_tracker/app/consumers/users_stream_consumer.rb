# frozen_string_literal: true

class UsersStreamConsumer < ApplicationConsumer
  def consume
    events = params_batch.payloads.reduce({}) do |total, event|
      event_data = event['data']
      total[event_data['public_id']] = (total[event_data['public_id']] || {}).merge(event_data)
      total
    end
    User.upsert_all(events.values, unique_by: :public_id)
  end
end
