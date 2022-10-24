class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  before_action :authenticate_user!
  before_action :set_locale, :session_var

  skip_before_action :verify_authenticity_token, :only => :create


  def change_user_locale
    if I18n.locale_available? permit_params[:locale].downcase
      current_user.update(locale: permit_params[:locale]) if current_user.present?
    end
    url_hash = Rails.application.routes.recognize_path URI(request.referer).path
    redirect_to url_hash, status: 303
  end


  def add_returning_path
    find_and_remove_breadcrumb
    if permit_path_to_return_params[:path_to_return].present?
      if session[:path_to_return].present?
        unless URI(request.referer).path == session[:path_to_return]&.last["path"]
          session[:path_to_return] << {
            "path" => permit_path_to_return_params[:path_to_return],
            "breadcrumb_name" => permit_path_to_return_params[:breadcrumb_name]
          }
        end
      else
        session[:path_to_return] << {
          "path" => permit_path_to_return_params[:path_to_return],
          "breadcrumb_name" => permit_path_to_return_params[:breadcrumb_name]
        }
      end
    end
  end

  def cancel_button
    if session[:path_to_return].present?
      if URI(request.referer).path == session[:path_to_return].last["path"]
        redirect_to root_path(active_tab: params[:returning_entity])
      else
        redirect_to session[:path_to_return].last["path"]
        session[:path_to_return].pop
      end
    else
      redirect_to root_path(active_tab: params[:returning_entity])
    end
  end

  private

  def find_item_inclusions(entity)
    ids = ItemDetail.where(detailable: entity).pluck(:item_id)
    if ids.present?
      Item.where(id: ids)
    else
      []
    end
  end

  def find_and_remove_breadcrumb
    if session[:path_to_return].present?
      number = nil
      session[:path_to_return].each_with_index do |breadcrumbs, index|
        if breadcrumbs["path"] == URI(request.fullpath).path
          number = index
          break
        end
      end
      if number.present?
        session[:path_to_return] = session[:path_to_return][0..(number - 1)]
        session[:path_to_return] = [] if number == 0
      end
    end
  end

  def session_var
    session[:path_to_return] = [] unless session[:path_to_return].present?
  end

  def permit_params
    params.permit(:locale, :url)
  end

  def permit_path_to_return_params
    params.permit(:path_to_return, :breadcrumb_name)
  end

  def set_locale
    I18n.locale = current_user&.locale.nil? ? I18n.default_locale : current_user.locale
  end

end
