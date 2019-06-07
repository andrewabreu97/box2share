class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_folder, only: [:browse]
  before_action :set_folder, only: [:show, :destroy, :edit, :update]

  layout 'panel'

  def index
  end

  def show
  end

  def new
    @folder = current_user.folders.build

    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
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
        redirect_to panel_files_path
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @folder.update_attributes(folder_params)
      flash[:notice] = "La caperta se ha renombrado correctamente."
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to panel_files_path
      end
    else
      render :edit
    end
  end

  def destroy
    @parent_folder = @folder.parent
    @folder.destroy
    flash[:notice] = "La carpeta y todo su contenido se han eliminado correctamente."
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to panel_files_path
    end
  end

  def browse
    if @current_folder
      @folders = @current_folder.children
      @assets = @current_folder.assets
    else
      flash[:alert] = "No tienes permiso para acceder a esta carpeta."
      redirect_to panel_files_path
    end
  end

  private
    def folder_params
      params.require(:folder).permit(:name, :parent_id)
    end

    def set_current_folder
      @current_folder = current_user.folders.find(params[:folder_id])
    end

    def set_folder
      @folder = current_user.folders.find(params[:id])
    end

end
