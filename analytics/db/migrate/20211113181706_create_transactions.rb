class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.string :type, null: false, default: ""
      t.belongs_to :user, foreign_key: true, null: false
      t.references :source, polymorphic: true

      t.uuid :public_id, null: false, index: { unique: true }

      t.timestamp :created_at
    end
  end
end
