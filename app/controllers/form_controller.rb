require 'rubygems'
require 'json'
class FormController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    protect_from_forgery :only => :index
    def home
    end

    def new
        puts "输出厕所"
    end

    def del
        form_id=params[:form_id].to_i
        if Form.find(form_id).destroy
            redirect_to show_path
        end
    end

    def show
        user_obj=User.find(current_user.id)
        @forms=user_obj.forms
    end
    
    def create
        form_name=Time.now
        user_obj=User.find(current_user.id)
        session[:user_obj]=user_obj
        form_obj=user_obj.forms.build(name:form_name)
        form_obj.save
        filed_dates=params[:properties]
        filed_save(filed_dates,form_obj)
        
    end
    

    def edit
        # user_obj=User.find(current_user.id)
        # user_obj.forms.find_each do|form|
        @form_id=params[:form_id].to_i
        session[:form_id] = @form_id
        form=Form.find(params[:form_id].to_i)
        puts form.name,"-----表单------"
        forms_list=[]
        form.fileds.find_each do|filed|
            s=eval(filed.extra)
            forms_list.push(s)
            puts s.class
        end
        @json_form= JSON.generate(forms_list)
        filed_dates=params[:properties]
        # end
    end

    def update
        # form_name=Time.now
        # user_obj=User.find(current_user.id)
        form_obj=Form.find(session[:form_id])
        filed_dates=params[:properties]
        filed_save(filed_dates,form_obj)
    end

    def filed_save(filed_dates,form_obj)
        filed_dates=JSON.parse(filed_dates)
        filed_dates.each do |filed_date|
            filed_name=filed_date["name"]
            filed_label=filed_date["label"]
            filed_type=filed_date["type"]
            value_content=filed_date["value"]
            extra_data=filed_date
            
            filed_obj=form_obj.fileds.build(name:filed_name,label:filed_label,f_type:filed_type,extra:extra_data)
            filed_obj.save

            value_obj=filed_obj.values.build(content:value_content,userid:current_user.id).save
            if filed_obj
                puts "表单项保存成功"
                
            else
                puts "表单项保存失败"
            end
        end
        redirect_to show_path
        puts "表单创建完成",filed_dates
    end
end