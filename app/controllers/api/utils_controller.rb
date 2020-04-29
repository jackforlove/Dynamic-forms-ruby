class Api::UtilsController < Api::ApplicationController
  skip_before_action :check_auth_token

  # Parameters: {"file_type"=>"binary", "file_name"=>"1567669836337.png", "source"=>"app", "token"=>"d146ad403544f3cb4302da8efae7ecbc"}
  def fetch_s3_url
    file_type = params[:file_type]
    file_type = "application/#{params[:file_name].split(".").last}" if file_type.blank?

    query = {
        secretKey: Setting.s3_upload_key,
        fileName: params[:file_name],
        fileType: file_type,
    }.to_query

    response = RestClient.get("#{Setting.s3_upload_url}?#{query}")

    puts response.body
    render json: {errcode: 0, data: JSON.parse(response.body) }
  rescue
    render json: {errcode: -1, message: '网络错误' }
  end
end
