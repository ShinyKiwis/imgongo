class AttachmentsController < ApplicationController
  include AttachmentsHelper

  layout false
  before_action :fetch_album
  before_action :fetch_attachment, only: [:show, :destroy]


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

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    if @attachment.destroy
      redirect_to album_path(@album), notice: "Attachment is destroyed successfully!"
    else
      redirect_to album_path(@album), alert: @attachment.errors.full_messages.join(', ')
    end
  end

  private

  def fetch_album
    @album = current_user.albums.find(params[:album_id])
  end

  def fetch_attachment
    @attachment = @album.attachments.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(signed_ids: [])
  end
end
