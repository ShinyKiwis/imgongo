# == Schema Information
#
# Table name: albums
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_albums_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Album < ApplicationRecord
  belongs_to :user
  has_many :attachments, dependent: :destroy

  validates :name, presence: true
end
