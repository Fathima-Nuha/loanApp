class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :money, precision: 12, scale: 2, default: 10000

      t.timestamps
    end
  end
end
