# frozen_string_literal: true

class UsersRoleChangesConsumer < ApplicationConsumer
  def consume
    updates = params_batch.payloads.map do |event|
      { role: event['new_role'], public_id: event['public_id'] }
    end
    User.upsert_all(updates, unique_by: :public_id)
  end
end
