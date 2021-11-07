# frozen_string_literal: true

class UsersConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |p|
      case p['event']
      when 'UserRoleChanged'
        User.upsert(JSON.parse(p['data']), unique_by: :public_id)
      end
    end
  end
end
