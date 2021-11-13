# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :assignee, class_name: "User", optional: true

  enum status: {
    open: 'open',
    completed: 'completed'
  }
end
