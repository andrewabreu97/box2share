class SharedAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_existing_asset, only: [:new]
  before_action :require_existing_shared_asset, only: [:show]

  def show
  end

  def new
    @shared_asset = current_user.shared_assets.build
    if params[:asset_id]
      @shared_asset.asset_id = params[:asset_id]
    end
  end

  def create
    @shared_asset = current_user.shared_assets.build
    @shared_asset.asset_id = params[:shared_asset][:asset_id]
    @shared_asset.shared_email = params[:shared_asset][:shared_email]

    shared_user = User.find_by_email(params[:shared_asset][:shared_email])
    @shared_asset.shared_user_id = shared_user.id if shared_user

    @shared_asset.message = params[:shared_asset][:message]
    if @shared_asset.save
      UserMailer.share_link_email(@shared_asset).deliver_now
      redirect_to files_path, notice: "El archivo se ha compartido con el usuario."
    else
      render :new
    end
  end

  private
    def require_existing_asset
      #@file = params[:file_id].blank? ? ShareLink.file_for_token(params[:id]) : UserFile.find(params[:file_id])
      @asset = Asset.find(params[:asset_id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ya ha sido eliminado."
    end

    def require_existing_shared_asset
      @shared_asset = SharedAsset.find_by_shared_asset_token(params[:id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ya ha sido eliminado."
    end

end
