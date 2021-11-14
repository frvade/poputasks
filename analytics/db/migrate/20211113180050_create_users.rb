class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :name, null: true, default: ""
      t.string :role, null: false, default: ""
      t.boolean :active, null: false, default: false
      t.decimal :balance, null: false, default: 0

      t.uuid :public_id, null: false, index: { unique: true }
    end
  end
end
