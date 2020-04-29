class TestController < ApplicationController
    # layout 'kg' 当前控制器布局
    # layout :layout_fun
    # layout 'special'
    def root
        @first=params[:first_tag]
        @second=params[:second_tag]
    end

    def first
        # x=params[:first_tag]
        # y=params[:second_tag]
        # num=params[:num_tag].to_i
        # @first=x
        # @second=y
        # u=Test.find_by_name(x)
        # if u&&y==u.age.to_s
        #     @first="哈哈哈"
        #     @x=(1..3).to_a
        # elsif num== 1
        #     render html: "<strong>输入错误！</strong>".html_safe
        # elsif num==2
        #     render  xml: @first
        # elsif num==3
        #     render json: @first
        # elsif num==4
        #     render js: "alert('hello!');"
        # else
        #     # redirect_to root_path
        #     redirect_back(falback_location: root_path)
        # end
        # private
        #     def layout_fun
        #         return 'kg'
        #     end

    end
end
