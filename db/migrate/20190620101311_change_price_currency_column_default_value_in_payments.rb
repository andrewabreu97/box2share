class ChangePriceCurrencyColumnDefaultValueInPayments < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:payments, :price_currency, from: 'USD', to: 'EUR')
  end
end
