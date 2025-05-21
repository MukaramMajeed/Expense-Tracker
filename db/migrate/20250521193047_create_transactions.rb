class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.date :date
      t.string :category
      t.text :description
      t.string :transaction_type

      t.timestamps
    end
  end
end
