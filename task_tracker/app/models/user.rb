# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, foreign_key: :assignee_id

  enum role: {
    admin: 'admin',
    employee: 'employee'
  }
end
