class Admin::PanelController < Admin::ApplicationController

  layout 'panel'

  def service_statistics
    @users_count = User.count
    @folders_count = Folder.count
    @assets_count = Asset.count
    @uploaded_assets_count = User.sum(:uploaded_assets_count)
    @downloaded_assets_count = User.sum(:downloaded_assets_count)
    @shared_assets_count = User.sum(:shared_assets_count)

  end

end
