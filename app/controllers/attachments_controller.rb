class AttachmentsController < ApplicationController
  include AttachmentsHelper

  layout false
  before_action :fetch_album

  def new
  end

  def create
    signed_ids = attachment_params[:signed_ids]
    return head :unprocessable_entity unless signed_ids.present?

    errors = []
    signed_ids.each do |signed_id|
      attachment = @album.attachments.new(user: current_user)
      attachment.file_type = file_type_by_signed_id(signed_id)
      attachment.file.attach(signed_id)
      errors << attachment.errors.full_messages.join(", ") unless attachment.save
    end

    if errors.present?
      flash.now[:alert] = errors.uniq.join('. ')
    else
      flash.now[:notice] = 'Your attachments are being processed!'
    end
  end

  private

  def fetch_album
    @album = current_user.albums.find(params[:album_id])
  end

  def attachment_params
    params.require(:attachment).permit(signed_ids: [])
  end
end
