class HomeController < ApplicationController

  def index
    @roles = Role.all
    @item_groups = ItemGroup.all
    @users = User.all
    @roles = Role.all
  end
end
