class RemoveSharedFilesCountFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :shared_files_count, :integer
  end
end
