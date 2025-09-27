class DirectUploadsController < ActiveStorage::DirectUploadsController
  before_action :authenticate_user!
end
