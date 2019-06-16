class CreateSharedAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_assets do |t|
      t.references :user, foreign_key: true
      t.string :shared_email
      t.integer :shared_user_id
      t.integer :asset_id
      t.string :message
      t.string :shared_asset_token

      t.timestamps
    end

    add_index :shared_assets, :shared_user_id
    add_index :shared_assets, :asset_id
  end
end
