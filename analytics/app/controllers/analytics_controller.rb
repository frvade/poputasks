# frozen_string_literal: true

class AnalyticsController < ApplicationController
  before_action :authenticate_admin!

  # GET /transactions or /transactions.json
  def index
    @today_earnings_sum = - Transaction.by_time.sum(:amount)
    @expensive_tasks = Task.completed
                           .select("DISTINCT ON (completed_at::date) *")
                           .order("completed_at::date, price DESC")
    @profitable_popugs_count = User.profitable.count
  end
end
