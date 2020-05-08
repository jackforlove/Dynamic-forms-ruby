require 'rubygems'
require 'json'
class FormController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    before_action :signed_confirmation,only: [:create, :update, :submit,:new,:show,:del,:edit]
    protect_from_forgery :only => :index
    def home
        if signed_in?
            redirect_to show_path
        end
    end

    def before_new
    end

    def new
        form_name=params[:form_name]
        form_note=params[:form_note]
        user_obj=User.find(current_user.id)
        session[:user_obj]=user_obj
        form_obj=user_obj.forms.new(name:form_name,notes:form_note)
        form_obj.save
        session[:form_id] =form_obj.id
    end

    def create
        # form_name=current_user.name+ Time.now.to_i.to_s[6..10]
        # user_obj=User.find(current_user.id)
        # session[:user_obj]=user_obj
        # form_obj=user_obj.forms.build(name:form_name)
        # form_obj.save
        form_obj=Form.find(session[:form_id].to_i) 
        session[:form_id]=nil
        puts '-------------',form_obj.name
        filed_dates=params[:properties]
        filed_save(filed_dates,form_obj)
        
    end
    
    def del
        form_id=params[:form_id].to_i
        if Form.find(form_id).destroy
            redirect_to show_path
        end
    end
    def show
        user_obj=User.find(current_user.id)
        @forms = user_obj.forms.order(created_at: :desc).page(params[:page]).per(5)
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
            s=eval(filed.extra.to_s)
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
        # end
    end

    def update
        # form_name=Time.now
        # user_obj=User.find(current_user.id)
        form_obj=Form.find(session[:form_id])
        session[:form_id]=nil
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
            puts "---------",filed.extra.class
            s=eval(filed.extra.to_s)
    
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
    end
    
    def save
        filed_dates=params[:properties]
        filed_dates=JSON.parse(filed_dates)
        form_obj=Form.find(session[:form_id])
        session[:form_id]=nil
        value_list=[]
        filed_dates.each do|f|
            type=f["type"]
            must_in=f["required"]
            min=f["min"]
            max=f["max"]
            value=f["value"]
            subtype = f["subtype"]
            values=f["values"]
            if !values
                value_list.push(value)
            else
                values.each do|v|
                    if v["selected"]
                        value_list.push(v["value"])
                    end
                end
            end
            if must_in
                return unless !value.nil?
            end

            if min && max && min <= max 
                return unless value.length >= min && value.length <= max
            end

            if subtype == "password" 
                return unless value =~ /^(?![0-9a-z]+$)(?![a-zA-Z]+$)(?![0-9A-Z]+$)[0-9a-zA-Z]{6,}$/
            end

            if subtype == "tel"
            end

            if subtype == "email"
                return unless value=~/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            end
        end
        puts "-------值得长度----",value_list
        tmp=form_obj.form_users.new(user_id:current_user.id)
        tmp.save
        form_obj.fileds.each do|f|
            f.values.new(content:value_list[0],form_user_id:tmp.id).save
            value_list.delete_at(0)
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

    def user_date
        form_id=params[:form_id]
        session[:form_id]=form_id.to_i
        @datas=Form.find(form_id).form_users.page(params[:page]).per(5)
    end

    def del_data
        value_id=params[:value_id].to_i
        if FormUser.find(value_id).destroy
            redirect_to 'http://localhost:3000/userdate?form_id='+session[:form_id].to_s
        end
    end

    def detail_form_user
        @form=FormUser.find(params[:form_user_id]).form
    end
    def form_link
    end
    private
    def signed_confirmation
        redirect_to root_path unless signed_in?   
    end
end