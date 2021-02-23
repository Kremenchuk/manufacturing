class HomeController < ApplicationController

  def index
    @roles = Role.all
    @item_groups = ItemGroup.all
  end
end
