require 'rest-client'

class UserSessionsController < ApplicationController
  before_action :check_authority, :only => [ :login, :destroy, :index ]
  protect_from_forgery :except => [:create]

  # omniauth callback method
  def mxl
    puts("123")
  end
  def create
    omniauth = request.env['omniauth.auth']
    user_info = omniauth["extra"]
    logger.debug "+++ #{omniauth}"

    # if user.present?
    user = save_user_info(omniauth)
    p 2323232, omniauth['uid']
    session[:uuid] = omniauth['uid']
    # 前端新项目放在这里
    path = root_path

    redirect_to(path)
  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]
  end

  def login
    path = "/fronts/#/login?token=#{current_user.access_token}"

    redirect_to(path)
  end


  def logout
    session[:uuid] = nil

    redirect_to "#{Setting.sso_host}/users/sign_out?redirect_url=http://#{request.env['HTTP_HOST']}"
  end

  private
  def save_user_info(omniauth)
    user = User.find_or_create_by!(login: omniauth['extra']['login'])
    user.available ||= 1
    user.uuid = omniauth['uid']
    user.name = omniauth['extra']['name']
    user.login  = omniauth['extra']['login']
    user.category = omniauth['extra']['type_id']
    user.school_ids = omniauth['extra']['school_ids']
    if omniauth['extra']['avatar'].present?
      user.avatar = omniauth['extra']['avatar']
    end

    user.save!

    user
  end
end