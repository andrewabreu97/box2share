class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :download]
  before_action :authenticate_user!

  layout 'panel'

  def show
  end

  def new
    @asset = current_user.assets.build
  end

  def create
    @asset = current_user.assets.build(asset_params)
    puts @asset.uploaded_file.byte_size
    if current_user.has_available_storage_space?(@asset.uploaded_file.byte_size)
      if @asset.save
        current_user.increment!(:uploaded_files_count)
        redirect_to panel_files_path, notice: 'El archivo se ha subido correctamente.'
      else
        render :new
      end
    else
      flash[:alert] = "No tienes suficiente espacio de almacenamiento."
      render :new
    end
  end

  def destroy
    @asset.destroy
    redirect_to panel_files_path, notice: 'El archivo se ha eliminado correctamente.'
  end

  def download
    if @asset
      cookies['fileDownload'] = 'true'
      current_user.increment!(:downloaded_files_count)
      send_data @asset.uploaded_file.download, filename: @asset.uploaded_file.filename.to_s, content_type: @asset.uploaded_file.content_type
    else
      flash[:alert] = "Este archivo no es tuyo, no puedes descargarlo."
      redirect_to root_path
    end
  end

  private
    def set_asset
      @asset = current_user.assets.find(params[:id])
    end

    def asset_params
      params.fetch(:asset,{}).permit(:uploaded_file)
    end
end
