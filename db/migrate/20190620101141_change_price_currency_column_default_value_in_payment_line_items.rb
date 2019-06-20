class ChangePriceCurrencyColumnDefaultValueInPaymentLineItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:payment_line_items, :price_currency, from: 'USD', to: 'EUR')
  end
end
