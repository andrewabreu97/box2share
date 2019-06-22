class AssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :download]
  before_action :set_current_folder, only: [:new]

  layout 'panel'

  def show
    authorize! :show, @asset, message: "No tienes acceso a este archivo."
  end

  def new
    @asset = current_user.assets.build
    if params[:id]
      authorize! :new, @current_folder, message: "No tienes acceso a esta carpeta."
      @asset.folder_id = @current_folder.id
    end
  end

  def create
    @asset = current_user.assets.build(asset_create_params)
    unless @asset.uploaded_file.attachment
      unless @asset.save
        @asset.errors.delete(:name) if @asset.errors[:name].any?
        render :new
      end
    else
      @asset.update(name: @asset.uploaded_file.filename.base)
      if current_user.has_available_storage_space?(@asset.uploaded_file.byte_size)
        if @asset.save
          current_user.increment!(:uploaded_files_count)
          flash[:notice] = 'El archivo se ha subido correctamente.'
          if @asset.folder
            redirect_to browse_path(@asset.folder)
          else
            redirect_to files_path
          end
        else
          render :new
        end
      else
        flash[:alert] = "No tienes suficiente espacio de almacenamiento en tu cuenta."
        render :new
      end
    end
  end

  def edit
    authorize! :edit, @asset, message: "No tienes acceso a este archivo."
  end

  def update
    authorize! :update, @asset, message: "No tienes acceso a este archivo."
    @asset.update(asset_update_params)
    if @asset.save
      @asset.uploaded_file.blob.update(filename: "#{@asset.name}.#{@asset.uploaded_file.filename.extension}")
      redirect_to files_path, notice: "El archivo ha sido renombrado correctamente."
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @asset, message: "No tienes acceso a este archivo."
    @parent_folder = @asset.folder
    @asset.destroy
    flash[:notice] = 'El archivo se ha eliminado correctamente.'
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to files_path
    end
  end

  def download
    authorize! :download, @asset, message: "No tienes acceso a este archivo."
    if @asset
      current_user.increment!(:downloaded_files_count)
      send_data @asset.uploaded_file.download, filename: @asset.uploaded_file.filename.to_s, content_type: @asset.uploaded_file.content_type
    end
  end

  private
    def asset_create_params
      params.fetch(:asset,{}).permit(:uploaded_file, :folder_id)
    end

    def asset_update_params
      params.fetch(:asset,{}).permit(:name)
    end

    def set_asset
      @asset = Asset.find(params[:id])
    rescue
      redirect_to files_path, alert: "Este archivo no existe o ha sido eliminado."
    end

    def set_current_folder
      @current_folder = Folder.find(params[:id]) if params[:id]
    rescue
      redirect_to files_path, alert: "Esta carpeta no existe o ha sido eliminada."
    end

end
