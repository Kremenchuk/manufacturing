class UsersController < ApplicationController


  before_action :find_user, only: [:edit, :destroy]

  def create
    user = User.new
    user.email = permit_params[:email]
    user.password = permit_params[:password]
    user.role = Role.find(permit_params[:role])
    user.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def edit
    @user.email = permit_params[:email]
    if permit_params[:password].empty?
      @user.encrypted_password = @user.encrypted_password
    else
      @user.password = permit_params[:password]
    end
    @user.role = Role.find(permit_params[:role])
    @user.save!
    redirect_to root_path(active_tab: 'administration')
  end

  def destroy
    if @user.destroy!
      flash[:messages] = "'#{@user.email}' удалено"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'administration')
    else
      flash[:messages] = "'#{@user.name}' не удалено #{@user.errors}"
      flash[:class] = 'flash-error'
    end
  end

  private

  def permit_params
    params.require(:user).permit(:email, :password, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end
end

