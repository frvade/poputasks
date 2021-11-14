class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :jira_id
      t.text :description
      t.string :status

      t.uuid :public_id, null: false, index: { unique: true }

      t.decimal :price, null: false, default: 0

      t.timestamp :created_at
    end
  end
end
