class Task < ApplicationRecord
  belongs_to :assignee, class_name: "User", optional: true

  def full_title
    "#{title} [#{jira_id}]"
  end
end
