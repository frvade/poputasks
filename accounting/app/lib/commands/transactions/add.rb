# frozen_string_literal: true

module Commands
  module Transactions
    class Add < Resol::Service
      param :user, SmartCore::Types::Protocol::InstanceOf(User)
      param :source, SmartCore::Types::Protocol::InstanceOf(Task)
      param :amount, SmartCore::Types::Value::Numeric

      def call
        transaction = Transaction.new(user: user, source: source, amount: amount, public_id: SecureRandom.uuid,
                                      type: (amount > 0 ? :deposit : :withdraw))
        transaction.transaction do
          transaction.save!
          user.update("balance = balance + ?", amount)
        end
        fail! unless transaction.persisted?

        transaction.attributes in { amount:, type:, public_id: , user: { public_id: } } => event_data
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
