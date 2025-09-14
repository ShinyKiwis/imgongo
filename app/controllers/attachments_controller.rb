class AttachmentsController < ApplicationController
  layout false
  before_action :fetch_album

  def new
    @attachment = current_user.attachments.new
  end

  def create
    attachments = attachment_params[:files].map do |file|
      @album.attachments.new(file: file, file_type: file.content_type, user: current_user)
    end

    all_valid = attachments.all?(&:valid?)

    if all_valid
      #Enqueue job
      redirect_to album_path(@album), notice: 'Attachments are being uploaded!'
    else
      @validation_errors = attachments.flat_map do |attachment|
        attachment.errors.full_messages
      end.uniq

      render status: :unprocessable_entity
    end
  end

  private

  def fetch_album
    @album = current_user.albums.find(params[:album_id])
  end

  def attachment_params
    params.require(:attachment).permit(files: [])
  end
end
