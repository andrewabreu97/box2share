class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_folder, only: [:browse]

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
  end

  def destroy
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
      params.require(:folder).permit(:name)
    end

    def set_current_folder
      @current_folder = current_user.folders.find(params[:folder_id])
    end

end
