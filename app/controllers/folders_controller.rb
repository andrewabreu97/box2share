class FoldersController < ApplicationController
  before_action :authenticate_user!

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

  private
    def folder_params
      params.require(:folder).permit(:name)
    end

end
