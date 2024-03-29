class RolesController < ApplicationController

  before_action :find_role, only: [:edit, :destroy]


  def create
    role = Role.new(permit_params)
    role.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def edit
    add_returning_path
    @role.attributes = permit_params
    @role.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def destroy
    if @role.destroy
      flash[:messages] = "'#{@role.name}' #{t('all_form.deleted')}"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'administration')
    else
      flash[:messages] = "'#{@role.name}' #{t('all_form.not_deleted')} #{@role.errors}"
      flash[:class] = 'flash-error'
    end
  end

  private

  def permit_params
    params.require(:role).permit(:name, :available_classes)
  end

  def find_role
    @role = Role.find(params[:id])
  end
end
