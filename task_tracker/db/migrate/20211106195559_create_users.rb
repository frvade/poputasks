class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: true
      t.string :role, null: false
      t.boolean :active, null: false
      t.uuid :public_id, null: false
      t.timestamp :disabled_at, null: true

      t.timestamps null: false
    end

    add_index :users, :public_id, unique: true
  end
end
