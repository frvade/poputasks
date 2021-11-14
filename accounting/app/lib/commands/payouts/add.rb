# frozen_string_literal: true

module Commands
  module Payouts
    class Add < Resol::Service
      param :user, SmartCore::Types::Protocol::InstanceOf(User)
      param :transactions, SmartCore::Types::Variadic::ArrayOf(Transaction)

      def call
        amount = transactions.sum(&:amount)
        success! if amount <= 0

        payout = Payout.new(user: user, amount: amount, public_id: SecureRandom.uuid,
                            transaction_ids: transactions.map(&:id))
        payout.transaction do
          payout.save!
          User.where(id: user.id).update_all(["balance = balance - ?", payout.amount])
        end
        fail! unless payout.persisted?
        # if system fails here we can find payouts which aren't source for any transaction
        # and create corresponding transactions
        Commands::Transactions::Add.call!(user, payout, payout.amount)

        event_data = {
          amount: payout.amount, public_id: payout.public_id,
          transaction_public_ids: transactions.map(&:public_id),
          user: { public_id: user.public_id }
        }
        event = {
          event_name: 'PayoutAdded',
          event_version: 1,
          data: event_data
        }
        EventProducer.produce_sync(event, 'payouts.added', 'payouts-add')

        success!(payout)
      end
    end
  end
end
