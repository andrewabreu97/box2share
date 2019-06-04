class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :download]
  before_action :authenticate_user!

  layout 'panel'

  def index
    @assets = current_user.assets
  end

  # def show
  # end

  def new
    @asset = current_user.assets.build
  end

  # def edit
  # end

  def create
    @asset = current_user.assets.build(asset_params)

    respond_to do |format|
      if @asset.save
        format.html { redirect_to panel_files_path, notice: 'El archivo se ha subido correctamente.' }
        #format.json { render :show, status: :created, location: @asset }
      else
        format.html { render :new }
        #format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   respond_to do |format|
  #     if @asset.update(asset_params)
  #       format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @asset }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @asset.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @asset.destroy
  #   respond_to do |format|
  #     format.html { redirect_to assets_url, notice: 'Asset was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

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
