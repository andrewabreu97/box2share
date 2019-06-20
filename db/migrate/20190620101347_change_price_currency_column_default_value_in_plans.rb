class ChangePriceCurrencyColumnDefaultValueInPlans < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:plans, :price_currency, from: 'USD', to: 'EUR')
  end
end
