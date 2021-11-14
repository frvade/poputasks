# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!

  # GET /transactions or /transactions.json
  def index
    transactions_dataset = current_user.admin? ? Transaction : Transaction.by_user(current_user)
    @transactions = transactions_dataset.includes(:source, :user).for_dashboard.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])
  end

  def payout
    DailyPayoutJob.perform_now

    redirect_to transactions_path, notice: "Payout created"
  end

  def today_earnings_sum
    - Transaction.where("created_at > ?", Date.today).sum(:amount)
  end
  helper_method :today_earnings_sum
end
