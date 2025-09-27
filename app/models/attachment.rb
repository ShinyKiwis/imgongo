# == Schema Information
#
# Table name: attachments
#
#  id          :bigint           not null, primary key
#  description :string
#  file_type   :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_attachments_on_album_id  (album_id)
#  index_attachments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (user_id => users.id)
#
class Attachment < ApplicationRecord
  ACCEPTABLE_ATTACHMENT_FORMATS = %w[image/png image/jpeg image/gif image/webp]
  FILE_SIZE_LIMIT = 5.megabytes

  belongs_to :album
  belongs_to :user

  has_one_attached :file

  validates :file,
            attached: true,
            content_type: ACCEPTABLE_ATTACHMENT_FORMATS,
            size: { less_than: FILE_SIZE_LIMIT, message: "must be less than #{FILE_SIZE_LIMIT}MB" }

  def thumb
    file.variant(resize_to_fit: [nil, 200])
  end
end
