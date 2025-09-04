class DashboardsController < ApplicationController
  def show
    @albums = current_user.albums
  end
end
