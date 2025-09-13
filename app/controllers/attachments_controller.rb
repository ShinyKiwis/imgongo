class AttachmentsController < ApplicationController
  layout false
  before_action :fetch_album

  def new
    @attachment = current_user.attachments.new
  end

  def create
  end

  private

  def fetch_album
    @album = current_user.albums.find(params[:album_id])
  end

  def attachment_params
    params.require(:attachment).permit(:files)
  end
end
