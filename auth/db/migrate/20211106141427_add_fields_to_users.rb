# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      CREATE TYPE user_roles AS ENUM ('admin', 'employee');
    SQL
    add_column :users, :role, :user_roles, null: false, default: 'employee'
    add_column :users, :active, :bool, null: false, default: true
    add_column :users, :disabled_at, :timestamp, null: true
  end

  def down
    remove_column :users, :active
    remove_column :users, :role
    execute <<~SQL
      DROP TYPE user_roles;
    SQL
  end
end
