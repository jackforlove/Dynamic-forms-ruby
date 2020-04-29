module Authable
  extend ActiveSupport::Concern
  included do
    helper_method :current_user
    helper_method :signed_in?
  end

  def set_default_values
    @page_title ||= "运维系统"
  end

  def redirect_back_or(default)
    redirect_to (cookies[:return_to] || default)
    cookies.delete(:return_to)
  end

  def store_location
    cookies[:return_to] = request.fullpath if request.get?
  end

  def signed_in?
    !current_user.nil?
  end

  def check_authority
    unless current_user.present?
      respond_to do |format|
        format.html  {
          redirect_to '/auth/joshid'
        }
        format.json {
          render :json => { 'error' => 'Access Denied' }.to_json
        }
      end
    end
  end

  def check_admin
    unless current_user.role == 0
      render :json => { 'error' => 'Access Denied' }
      return
    end
  end

  def redirect_error_page(msg)
    @message = msg
    render"custom_errors/index" and return
  end

  def current_user
    # p 1111,  session[:uuid]
    return nil unless session[:uuid]
    @current_user ||= User.find_by(uuid: session[:uuid])

    @current_user
  end
end