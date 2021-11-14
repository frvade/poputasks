class CreatePayouts < ActiveRecord::Migration[6.1]
  def change
    create_table :payouts do |t|
      t.decimal :amount
      t.references :user, null: false, foreign_key: true
      t.integer :transaction_ids, array: true, default: []

      t.uuid :public_id, null: false, index: { unique: true }, default: "gen_random_uuid()"

      t.timestamps
    end
  end
end
