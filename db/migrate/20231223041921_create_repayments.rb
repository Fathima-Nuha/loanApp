class CreateRepayments < ActiveRecord::Migration[7.0]
  def change
    create_table :repayments do |t|
      t.references :loan, null: false, foreign_key: true
      t.datetime :payment_date
      t.decimal :amount, precision: 7, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
