require 'rubygems'
require 'json'
class FormController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    def home
    end

    def new
        puts "输出厕所"
    end
    
    def create
        filed_date=params[:properties]
        filed_name=JSON.parse(filed_date)[0]["name"]
        filed_label=JSON.parse(filed_date)[0]["label"]
        filed_type=JSON.parse(filed_date)[0]["type"]
        value_content=JSON.parse(filed_date)[0]["value"]
        form_name="TEST"

        user_obj=User.find(current_user.id)
        form_obj=user_obj.forms.build(name:form_name)
        form_obj.save

        filed_obj=form_obj.fileds.build(name:filed_name,label:filed_label,f_type:filed_type)
        filed_obj.save

        value_obj=filed_obj.values.build(content:value_content,userid:current_user.id).save
        if filed_obj
            puts "保存成功"
        else
            puts "保存失败"
        end
        puts "输出测试",filed_date,user_obj
    end
    

    def edit
    end
end