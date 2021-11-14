# frozen_string_literal: true

class AddJiraIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :jira_id, :string, null: false, default: ""
  end
end
