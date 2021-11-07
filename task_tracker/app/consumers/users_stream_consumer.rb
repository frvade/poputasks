# frozen_string_literal: true

class UsersStreamConsumer < ApplicationConsumer
  def consume
    payloads = params_batch.payloads.map { |p| JSON.parse(p['data']) }
    User.upsert_all(payloads, unique_by: :public_id)
  end
end
