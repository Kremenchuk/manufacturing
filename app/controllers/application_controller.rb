class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => :create
end
