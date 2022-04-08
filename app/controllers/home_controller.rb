class HomeController < ApplicationController

  def index
    session[:path_to_return] = []
    @item_groups = ItemGroup.all
    @users = User.all
    @roles = Role.all
  end
end
