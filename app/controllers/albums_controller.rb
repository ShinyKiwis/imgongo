class AlbumsController < ApplicationController
  before_action :fetch_albums

  def new
    @album = current_user.albums.new
  end

  def show
    @album = current_user.albums.find(params[:id])
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

  private

  def album_params
    params.require(:album).permit(:name, :description)
  end

  def fetch_albums
    @albums = current_user.albums.select(&:persisted?)
  end
end
