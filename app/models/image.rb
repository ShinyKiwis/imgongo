# == Schema Information
#
# Table name: images
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_images_on_album_id  (album_id)
#  index_images_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (user_id => users.id)
#
class Image < ApplicationRecord
  belongs_to :album
  belongs_to :user
end
