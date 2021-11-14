# frozen_string_literal: true

class Transaction < ApplicationRecord
  scope :by_time, -> (from: Date.today, till: Date.tomorrow) { where("created_at BETWEEN ? and ?", from, till) }
end
