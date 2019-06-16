class SharedAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_existing_asset, only: [:new]

  def new
  end

  def create
  end

  private
    def require_existing_asset
      #@file = params[:file_id].blank? ? ShareLink.file_for_token(params[:id]) : UserFile.find(params[:file_id])
      @asset = Asset.find(params[:asset_id])
      #@folder = @file.folder
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ya ha sido eliminado."
    end

end
