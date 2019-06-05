class AddFilesStatsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :downloaded_files_count, :integer, default: 0, null: false
    add_column :users, :uploaded_files_count, :integer, default: 0, null: false
    add_column :users, :shared_files_count, :integer, default: 0, null: false
  end
end
