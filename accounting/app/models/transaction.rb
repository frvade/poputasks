# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :source, polymorphic: true

  enum type: {
    deposit: 'deposit',
    withdraw: 'withdraw'
  }
end
