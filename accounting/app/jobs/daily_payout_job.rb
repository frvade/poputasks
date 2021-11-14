# frozen_string_literal: true

class DailyPayoutJob < ApplicationJob
  queue_as :default

  def perform(time = Date.today)
    transactions = Transaction
      .joins(:user)
      .includes(:user)
      .joins("LEFT JOIN payouts p ON p.user_id = users.id AND p.id = (SELECT max(id) from payouts WHERE p.id = payouts.id)")
      .where("transactions.created_at > p.created_at OR p.created_at IS NULL")
      .where("transactions.created_at < ?", time)

    transactions.all.group_by(&:user).each do |(user, transaction_group)|
      Commands::Payouts::Add.call!(user, transaction_group)
    end
  end
end
