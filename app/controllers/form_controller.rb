require 'rubygems'
require 'json'
class FormController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    before_action :signed_confirmation,only: [:create, :update, :submit,:new,:show,:del,:edit]
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
        form_name=current_user.name+ Time.now.to_i.to_s[6..10]
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
        form=Form.find(@form_id)
        puts form.name,"-----表单------"
        forms_list=[]
        form.fileds.find_each do|filed|
            s=eval(filed.extra)
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
        # end
    end

    def update
        # form_name=Time.now
        # user_obj=User.find(current_user.id)
        form_obj=Form.find(session[:form_id])
        form_obj.fileds.find_each do|x|
            x.extra=nil
            x.save
        end
        filed_dates=params[:properties]
        filed_save(filed_dates,form_obj)
    end

    def fill
        form_id=params[:form_id].to_i
        session[:form_id] = form_id
        form=Form.find(form_id)
        forms_list=[]
        form.fileds.find_each do|filed|
            s=eval(filed.extra)
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
    end
    
    def save
        filed_dates=params[:properties]
        filed_dates=JSON.parse(filed_dates)
        form_obj=Form.find(session[:form_id])
        value_list=[]
        filed_dates.each do|f|
            must_in=f["required"]
            value=f["value"]
            value_list.push(value)
            if must_in
                return unless !value.nil?
            end
        end
        form_obj.fileds.find_each do|x|
            if value_list
                n=value_list[0]
                x.values.build(content:n,userid:current_user.id).save
                value_list.delete(n)
            end
        end
        redirect_to show_path
    end
    

    def filed_save(filed_dates,form_obj)
        filed_dates=JSON.parse(filed_dates)
        filed_dates.each do |filed_date|
            filed_name=filed_date["name"]
            filed_label=filed_date["label"]
            filed_type=filed_date["type"]
            extra_data=filed_date
            if extra_data.has_key?("value")
              extra_data["value"]=nil
            end
            filed_obj=form_obj.fileds.find_by(name:filed_name)
            if filed_obj
                filed_obj.update(extra:extra_data)
            else
                filed_obj=form_obj.fileds.build(name:filed_name,label:filed_label,f_type:filed_type,extra:extra_data).save  
            end
        end
        redirect_to show_path
    end
    private
    def signed_confirmation
        redirect_to root_path unless signed_in?   
    end
end