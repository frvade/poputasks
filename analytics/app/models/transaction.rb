# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  scope :by_time, -> (from: Date.today, till: Date.tomorrow) { where("created_at BETWEEN ? and ?", from, till) }

  def self.inheritance_column
    "shitty_active_record"
  end
end
