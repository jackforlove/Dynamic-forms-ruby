require 'rubygems'
require 'json'
class FormController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    before_action :signed_confirmation,only: [:create, :update, :submit,:new,:show,:del,:edit,:del_data,:save,:user_data]
    protect_from_forgery :only => :index
    def home
        @forms = Form.all.order(created_at: :desc).page(params[:page]).per(5)
    end

    def new
    end

    def create
        form_obj=current_user.forms.new()
        form_obj.save
        filed_dates=params[:properties]
        filed_save(filed_dates,form_obj)
    end
    
    def del
        form_id=params[:form_id].to_i
        form_obj=Form.find(form_id)
        if form_obj.user.id == current_user.id
            if form_obj.destroy
                redirect_to show_path
            end
        end
    end

    def show
        @forms = current_user.forms.order(created_at: :desc).page(params[:page]).per(5)
    end
    
    def edit
        @form_id=params[:form_id].to_i
        session[:form_id] = @form_id
        form=Form.find(@form_id)
        forms_list=[]
        form.fileds.find_each do|filed|
            s=eval(filed.extra.to_s)
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
    end

    def update
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
                        value=v["value"]
                    end
                end
            end
            if must_in
                return unless !value.nil?
            end
            puts "--------"
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
        tmp=form_obj.form_users.new(user_id:current_user.id)
        tmp.save
        form_obj.fileds.each do|f|
            f.values.new(content:value_list[0],form_user_id:tmp.id).save
            value_list.delete_at(0)
        end
        redirect_to show_path
    end

    def user_data
        form_id=params[:form_id]
        @fields = Filed.where(form_id: form_id)
        session[form_id]=form_id
        select = " select u.id, u.name"
        if @fields.length != 0
          select += ","
        end
    
        join = " from `form_users` f left join `users` u on f.user_id = u.id "
        i = 0

        @fields.each do |field|
          i += 1
          select += " v" + i.to_s + ".content as key_" + field.id.to_s
          if i != @fields.length
            select += ", "
          end
    
          join += " left join `values` v" + i.to_s + " on `v" + i.to_s + "`.`form_user_id` = f.id and v" + i.to_s + ".filed_id = " + field.id.to_s
    
        end
        join += " where f.form_id =" + params[:form_id].to_s
        sql = select + join
        @datas = User.find_by_sql(sql)
        @form = Form.find(params[:form_id])
    end

    def del_data
        value_id=params[:value_id].to_i
        if FormUser.find(value_id).destroy
            # redirect_to "http://localhost:3000/userdata?form_id="+session[:form_id].to_s
            redirect_to show_path
        end
    end

    def detail_form_user
        # @fields = Filed.where(form_id: params[:form_id])
    end
    def search
        form_name=params[:form_name]
        @forms=Form.where("name like ?","%#{form_name}%").order(created_at: :desc).page(params[:page]).per(5)
        render 'home'
    end

    def search_current
        form_name=params[:form_name]
        @forms = current_user.forms.where("name like ?","%#{form_name}%").order(created_at: :desc).page(params[:page]).per(5)
        render 'show'
    end

    private
    def signed_confirmation
        redirect_to root_path unless signed_in?   
    end

    def filed_save(filed_dates,form_obj)
        filed_dates=JSON.parse(filed_dates)
        form_obj.fileds.find_each do |x|
            x.destroy
        end
        filed_dates.each do |filed_date|
            filed_name=filed_date["name"]
            filed_label=filed_date["label"]
            filed_type=filed_date["type"]
            extra_data=filed_date
            if filed_name =="title"
                form_obj.update(name:filed_date["value"])
            else
                if extra_data.has_key?("value")
                    extra_data["value"]=nil
                end
                filed_obj=form_obj.fileds.build(name:filed_name,label:filed_label,f_type:filed_type,extra:extra_data).save
            end
        end
        redirect_to show_path
    end
end