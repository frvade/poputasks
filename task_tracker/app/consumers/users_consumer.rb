# frozen_string_literal: true

class UsersConsumer < ApplicationConsumer
  def consume
    users = params_batch.payloads.reduce({}) do |total, event|
      event_data = event['data']
      public_id = event_data['public_id']

      case event.symbolize_keys
      in { event_name: 'UserCreated' } | { event_name: 'UserUpdated' }
        total[public_id] = (total[public_id] || {}).merge(event_data)
      in { event_name: 'UserRoleChanged' }
        total[public_id] = (total[public_id] || {}).merge(public_id: public_id, role: event_data['new_role'])
      in { event_name: 'UserDeleted' }
        total[public_id] = { public_id: public_id, active: false }
      else
        # store events in DB
      end

      total
    end

    User.upsert_all(users.values, unique_by: :public_id) if users.any?
  end
end
