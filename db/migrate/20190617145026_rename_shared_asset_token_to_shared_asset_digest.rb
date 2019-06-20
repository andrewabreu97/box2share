class RenameSharedAssetTokenToSharedAssetDigest < ActiveRecord::Migration[5.2]
  def change
    rename_column :shared_assets, :shared_asset_token, :shared_asset_digest
  end
end
