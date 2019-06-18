class PanelController < ApplicationController

  before_action :authenticate_user!

  layout 'panel'

  def dashboard
  end

  def plan
    @subscription = current_user.current_subscription
  end

  def files
    @folders = current_user.folders.roots
    @assets = current_user.assets.where("folder_id IS NULL")
  end

  def share_files
    @being_shared_assets = current_user.being_shared_assets
  end

end
