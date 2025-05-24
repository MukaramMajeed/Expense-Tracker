class AddCurrencyPreferenceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :currency_preference, :string, default: 'USD'
  end
end
