module Api::Rescueable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found
    # rescue_from ActiveRecord::RecordInvalid, with: :show_errors
  end

  private

  def rescue_record_not_found(e)
    render json: { code: 200404, message: "#{e}" }
  end

  def common_error(e)
    log_error(e)
    render json: { code: 200500, message: e.msg, error: e.class.name.underscore }
  end

  def rescue_all(e)
    log_error(e)
    render json: { code: 200500, message: "抱歉~ 系统出错了，攻城狮们已经在修理了！", error: e.class.name.underscore, original_message: e.message }
  end

  def log_error(e)
    logger.error e.message
    e.backtrace.each do |message|
      logger.error message
    end
  end
end

