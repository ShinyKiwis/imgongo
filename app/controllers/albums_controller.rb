class AlbumsController < ApplicationController
  before_action :fetch_albums
  before_action :fetch_album, only: [:show, :destroy]

  def new
    @album = current_user.albums.new
  end

  def create
    @album = current_user.albums.new(album_params)

    if @album.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    album_name = @album.name
    @album.destroy
    redirect_to root_path, notice: "'#{album_name}' is destroyed successfully!"
  end

  private

  def album_params
    params.require(:album).permit(:name, :description)
  end

  def fetch_albums
    @albums = current_user.albums.select(&:persisted?)
  end

  def fetch_album
    @album = current_user.albums.find(params[:id])
  end
end
