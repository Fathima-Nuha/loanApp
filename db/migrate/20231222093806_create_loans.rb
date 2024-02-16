class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :loan_amount,precision: 7, scale: 2, default: 0.0
      t.decimal :interest_rate,precision: 3, scale: 2, default: 5.0
      t.integer :status
      t.datetime :confirmed_by_user_at
      t.decimal :amount_to_repay, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
