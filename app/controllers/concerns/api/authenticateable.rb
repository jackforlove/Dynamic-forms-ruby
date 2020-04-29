module Api::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
  end

  private
  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Authorization,Origin,X-Requested-With,Content-Type,Accept,x-csrf-token'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def cors_set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def version_code
    @version_code ||= (params[:version] || request.headers.env['HTTP_VERSION_CODE'] || params[:version_code])
  end

  def get_token
    @token ||= request.headers.env['HTTP_TOKEN'] || params[:token]
  end
end
