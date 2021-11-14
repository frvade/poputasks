# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :user

  scope :by_user, -> (user) { where(user: user) }
  scope :by_day, -> (day = Date.today) { where("created_at > ?", day) }
  scope :ordered_by_time, -> { order(:created_at) }

  scope :for_dashboard, -> { by_day.ordered_by_time }

  enum type: {
    deposit: 'deposit',
    withdraw: 'withdraw'
  }

  def self.inheritance_column
    "shitty_active_record"
  end
end
