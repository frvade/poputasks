class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :name, null: true, default: ""
      t.string :role, null: false, default: ""
      t.boolean :active, null: false, default: false
      t.uuid :public_id, null: false, unique: true
      t.timestamp :disabled_at, null: true

      t.timestamps
    end
  end
end
