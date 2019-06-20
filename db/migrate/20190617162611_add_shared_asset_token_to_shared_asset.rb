class AddSharedAssetTokenToSharedAsset < ActiveRecord::Migration[5.2]
  def change
    add_column :shared_assets, :shared_asset_token, :string
    add_index :shared_assets, :shared_asset_token
  end
end
