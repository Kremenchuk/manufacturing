class ItemGroupsController < ApplicationController


  before_action :find_item_group, only: [:edit, :destroy]


  def create
    item_group = ItemGroup.new(permit_params)
    item_group.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def edit
    @item_group.attributes = permit_params
    @item_group.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def destroy
    if @item_group.destroy!
      flash[:messages] = "'#{@item_group.name}' удалено"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'administration')
    else
      flash[:messages] = "'#{@item_group.name}' не удалено #{@item_group.errors}"
      flash[:class] = 'flash-error'
    end
  end

  private

  def permit_params
    params.require(:item_group).permit(:name, :range)
  end

  def find_item_group
    @item_group = ItemGroup.find(params[:id])
  end
end

