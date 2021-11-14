# frozen_string_literal: true

class User < ApplicationRecord
  has_many :transactions
  has_many :payouts

  enum role: {
    admin: 'admin',
    employee: 'employee'
  }
end
