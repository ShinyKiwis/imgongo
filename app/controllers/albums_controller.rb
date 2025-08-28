class AlbumsController < ApplicationController
  def new
    @album = current_user.albums.new

    respond_to do |format|
      format.turbo_stream
    end
  end
end
