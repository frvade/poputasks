class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :jira_id
      t.text :description
      t.string :status
      t.references :assignee, index: true, foreign_key: { to_table: :users }
      t.uuid :public_id, null: false, index: { unique: true }

      t.decimal :price, null: false, default: 0
    end
  end
end
