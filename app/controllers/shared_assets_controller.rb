class SharedAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_asset, only: [:new, :members]
  before_action :set_shared_asset_by_token, only: [:show]
  before_action :require_valid_token, only: [:show]
  before_action :set_shared_asset_by_id, only: [:destroy]
  before_action :check_members, only: [:members]

  layout 'panel'

  authorize_resource @shared_asset, only: [:show]

  def show
  end

  def new
    authorize! :share, @asset, message: "No puedes compartir este archivo porque no es tuyo."
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

  def destroy
    @asset = @shared_asset.asset
    if @shared_asset.destroy
      flash[:notice] = "Has dejado de compartir el archivo con este usuario."
      if @asset.folder
        redirect_to browse_path(@asset.folder)
      else
        redirect_to files_path
      end
    end
  end

  def members
    authorize! :members, @asset, message: "No puedes puedes ver los miembros de este archivo porque no es tuyo."
    @members = @asset.shared_assets
  end

  private
    def set_asset
      @asset = Asset.find(params[:asset_id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ha sido eliminado."
    end

    def set_shared_asset_by_token
      @shared_asset = SharedAsset.find_by(shared_asset_token: params[:id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o han dejado de compartirlo."
    end

    def set_shared_asset_by_id
      @shared_asset = SharedAsset.find(params[:id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o han dejado de compartirlo."
    end

    def require_valid_token
      unless (@shared_asset && @shared_asset.authenticated?("shared_asset", params[:id]))
        redirect_to root_path
      end
    end

    def check_members
      unless @asset.shared_assets.count > 0
        redirect_to files_path, alert: "Necesitas haber compartido este archivo con al menos un usuario."
      end
    end

    def shared_asset_params
      params.require(:shared_asset).permit(:shared_email, :message, :asset_id)
    end

end
