# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def up
    enable_extension 'pgcrypto'

    execute <<~SQL
      CREATE TYPE task_status AS ENUM ('open', 'completed');
    SQL

    create_table :tasks do |t|
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""

      t.uuid :public_id, null: false, default: "gen_random_uuid()"

      t.references :assignee, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_column :tasks, :status, :task_status, null: false, default: "open"
  end

  def down
    drop_table :tasks

    execute <<~SQL
      DROP TYPE task_status;
    SQL
  end
end
