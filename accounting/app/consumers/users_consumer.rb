# frozen_string_literal: true

class UsersConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |event|
      event_data = event['data']
      public_id = event_data['public_id']

      case event['event_name']
      when 'UserCreated', 'UserUpdated'
      when 'UserRoleChanged'
        event_data = { public_id: public_id, role: event_data['new_role'] }
      when 'UserDeleted'
        event_data = { public_id: public_id, active: false }
      else
        # store events in DB
      end

      User.upsert(event_data, unique_by: :public_id) if event_data.dig("public_id")
    end
  end
end
