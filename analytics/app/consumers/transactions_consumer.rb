# frozen_string_literal: true

class TransactionsConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |event|
      event_data = event['data']

      case event['event_name']
      when 'TransactionAdded'
        source = event_data.delete("source")
        transaction_user = event_data.delete("user")
        user = User.find_by!(public_id: transaction_user["public_id"])
        transaction_data = event_data.merge(user: user, source_id: source["id"], source_type: source["type"] )
        Transaction.create!(transaction_data)
      else
        # store events in DB
      end
    end
  end
end
