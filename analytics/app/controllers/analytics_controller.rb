# frozen_string_literal: true

class AnalyticsController < ApplicationController
  before_action :authenticate_admin!

  # GET /transactions or /transactions.json
  def index
    @today_earnings_sum = - Transaction.by_time.sum(:amount)
    @expensive_tasks = Task
                         .where("tasks.id = (
                           SELECT DISTINCT ON (created_at::date)
                             id
                           FROM tasks t
                           ORDER BY created_at::date, price DESC
                         )")
    @profitable_popugs_count = User.profitable.count
  end
end
