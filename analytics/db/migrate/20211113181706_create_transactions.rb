class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.belongs_to :user, foreign_key: true, null: false
      t.references :source, polymorphic: true

      t.uuid :public_id

      t.timestamp :created_at
    end
  end
end
