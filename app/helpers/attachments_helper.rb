module AttachmentsHelper
  def file_type(content_type)
    return :image if image_file?(content_type)
  end

  def file_type_by_signed_id(signed_id)
    blob = ActiveStorage::Blob.find_signed(signed_id)
    file_type(blob&.content_type)
  end

  def image_file?(content_type)
    [
      'image/png',
      'image/jpeg',
      'image/gif',
      'image/webp',
      'image'
    ].include?(content_type)
  end
end
