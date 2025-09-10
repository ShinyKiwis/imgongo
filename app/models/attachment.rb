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
  belongs_to :album
  belongs_to :user
end
