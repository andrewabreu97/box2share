class AddNonSensibleCardDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :card_last4, :string
    add_column :users, :card_brand, :string
  end
end
