# frozen_string_literal: true

module Commands
  module Transactions
    class Add < Resol::Service
      param :user, SmartCore::Types::Protocol::InstanceOf(User)
      param :source, SmartCore::Types::Protocol::InstanceOf(Task, Payout)
      param :amount, SmartCore::Types::Value::Numeric

      def call
        transaction = Transaction.new(user: user, source: source, amount: amount, public_id: SecureRandom.uuid,
                                      type: (amount > 0 ? :deposit : :withdraw))
        transaction.transaction do
          transaction.save!
          User.where(id: user.id).update_all(["balance = balance + ?", amount])
        end
        fail! unless transaction.persisted?

        event_data = {
          amount: transaction.amount, type: transaction.type, public_id: transaction.public_id,
          source: { type: transaction.source_type, public_id: source.public_id },
          user: { public_id: user.public_id }
        }
        event = {
          event_name: 'TransactionAdded',
          event_version: 1,
          data: event_data
        }
        EventProducer.produce_sync(event, 'transactions.added', 'transactions-add')

        success!(transaction)
      end
    end
  end
end
