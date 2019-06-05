class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :download]
  before_action :authenticate_user!

  layout 'panel'

  def index
    @assets = current_user.assets
  end

  def show
  end

  def new
    @asset = current_user.assets.build
  end

  def edit
  end

  def create
    @asset = current_user.assets.build(asset_params)
    if @asset.save
      current_user.increment!(:uploaded_files_count)
      redirect_to panel_files_path, notice: 'El archivo se ha subido correctamente.'
    else
      render :new
    end
  end

  def update
  end

  def destroy
    @asset.uploaded_file.purge
    @asset.destroy
    redirect_to panel_files_path, notice: 'El archivo se ha eliminado correctamente.'
  end

  def download
    send_data @asset.uploaded_file.download, filename: @asset.uploaded_file.filename.to_s, content_type: @asset.uploaded_file.content_type
  end

  private
    def set_asset
      @asset = current_user.assets.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:uploaded_file)
    end
end
