class ApplicationController < ActionController::Base
    # before_action :check_authority
    include Authable
    # layout 'kg' 全局局部
    # layout 'global'
end

