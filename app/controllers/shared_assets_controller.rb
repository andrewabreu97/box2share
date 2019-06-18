class SharedAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_existing_asset, only: [:new]
  before_action :require_existing_shared_asset, only: [:show]
  before_action :require_valid_token, only: [:show]

  layout 'panel'

  authorize_resource @shared_asset, only: [:show]

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
    @shared_asset.asset_id = shared_asset_params[:asset_id]
    @shared_asset.shared_email = shared_asset_params[:shared_email]

    shared_user = User.find_by_email(shared_asset_params[:shared_email])
    @shared_asset.shared_user_id = shared_user.id if shared_user

    @shared_asset.message = shared_asset_params[:message]
    if @shared_asset.save
      UserMailer.share_link_email(@shared_asset).deliver_now
      flash[:notice] = "El archivo se ha compartido con el usuario."
      if @shared_asset.asset.folder
        redirect_to browse_path(@shared_asset.asset.folder)
      else
        redirect_to files_path
      end
    else
      render :new
    end
  end

  private
    def require_existing_asset
      @asset = Asset.find(params[:asset_id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ha sido eliminado."
    end

    def require_existing_shared_asset
      @shared_asset = SharedAsset.find_by(shared_asset_token: params[:id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o han dejado de compartirlo."
    end

    def require_valid_token
      unless (@shared_asset && @shared_asset.authenticated?("shared_asset", params[:id]))
        redirect_to root_path
      end
    end

    def shared_asset_params
      params.require(:shared_asset).permit(:shared_email, :message, :asset_id)
    end

end
