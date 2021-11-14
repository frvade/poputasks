class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    reversible do |dir|
      dir.up { execute "CREATE TYPE transaction_type AS ENUM ('withdraw', 'deposit');" }
      dir.down { execute "DROP TYPE transaction_type;" }
    end

    create_table :transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.belongs_to :user, foreign_key: true, null: false
      t.references :source, polymorphic: true

      t.uuid :public_id, null: false, index: { unique: true }, default: "gen_random_uuid()"

      t.timestamps
    end

    add_column :transactions, :type, :transaction_type, null: false
  end
end
