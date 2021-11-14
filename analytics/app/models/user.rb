# frozen_string_literal: true

class User < ApplicationRecord
  scope :profitable, ->() { where("balance < 0") }

  enum role: {
    admin: 'admin',
    employee: 'employee'
  }
end
