class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :browse]
  before_action :set_current_folder, only: [:new]

  layout 'panel'

  def show
    authorize! :show, @folder, message: "No tienes acceso a esta carpeta."
  end

  def new
    @folder = current_user.folders.build
    if params[:id]
      authorize! :new, @current_folder, message: "No tienes acceso a esta carpeta."
      @folder.parent_id = @current_folder.id
    end
  end

  def create
    @folder = current_user.folders.build(folder_params)
    if @folder.save
      flash[:notice] = "La carpeta se ha creado correctamente."
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to files_path
      end
    else
      render :new
    end
  end

  def edit
    authorize! :edit, @folder, message: "No tienes acceso a esta carpeta."
  end

  def update
    authorize! :update, @folder, message: "No tienes acceso a esta carpeta."
    if @folder.update_attributes(folder_params)
      flash[:notice] = "La carpeta se ha renombrado correctamente."
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to files_path
      end
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @folder, message: "No tienes acceso a esta carpeta."
    @parent_folder = @folder.parent
    if @folder.destroy
      flash[:notice] = "La carpeta y todo su contenido se han eliminado correctamente."
      if @parent_folder
        redirect_to browse_path(@parent_folder)
      else
        redirect_to files_path
      end
    end
  end

  def browse
    authorize! :browse, @folder, message: "No tienes acceso a esta carpeta."
    if @folder
      @subfolders = @folder.children
      @assets = @folder.assets
    end
  end

  private
    def folder_params
      params.require(:folder).permit(:name, :parent_id)
    end

    def set_folder
      @folder = Folder.find(params[:id])
    rescue
      redirect_to files_path, alert: "Esta carpeta no existe o ha sido eliminada."
    end

    def set_current_folder
      @current_folder = Folder.find(params[:id]) if params[:id]
    rescue
      redirect_to files_path, alert: "Esta carpeta no existe o ha sido eliminada."
    end

end
