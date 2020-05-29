require 'rubygems'
require 'json'
require 'base64'
require 'csv'

class FormController < ApplicationController
    # force_ssl
    skip_before_action :verify_authenticity_token, only: [:create, :update, :submit]
    before_action :signed_confirmation , only: [:create, :update, :submit,:new,:show,:del,:edit,:del_data,:user_data]
    protect_from_forgery :only => :index
    def home
        if signed_in?
            content = params[:content]
            search_id = params[:search_id].to_i
            if search_id == 1
                @forms = Form.where("name like ?","%#{content}%").order(created_at: :desc).page(params[:page]).per(5)
            elsif  search_id == 2
                users=User.where("name like ?","%#{content}%").order(created_at: :desc)
                u_id = nil
                if users.present?
                    u_id = users.first.id
                end
                if content.present?
                    @forms = Form.where(user_id:u_id).order(created_at: :desc).page(params[:page]).per(5)
                elsif
                @forms = Form.where("name like ?","%#{content}%").order(created_at: :desc).page(params[:page]).per(5)
                end
            else
                @forms = Form.all.order(created_at: :desc).page(params[:page]).per(5)
            end
            @forms = @forms.where("start_at >= ?", params[:date_from]) if params[:date_from].present?
            @forms = @forms.where("end_at <= ?", params[:date_to]) if params[:date_to].present?

            advance_forms = Time.now-100.years
            Form.where(user_id:current_user.id).find_each do|f|
                if f.form_users.present?
                    if f.form_users.last.updated_at >= advance_forms
                        advance_forms = f.form_users.last.updated_at
                    end
                end
            end
            @form_user=FormUser.find_by_updated_at(advance_forms)
        end
    end

    def new
    end

    def create
        filed_dates = params[:properties]
        filed_dates = JSON.parse(filed_dates)
        form_obj = current_user.forms.new(name:filed_dates[0]["value"],takon:Base64.encode64(Time.now.to_i.to_s).to_s,start_at:filed_dates[1]["value"],end_at:filed_dates[2]["value"],tag:true )
        form_obj.save
        session[:new_form_id]=form_obj.id
        redirect_to edit_path
    end

    def del
        form_id = params[:form_id].to_i
        form_obj = Form.find(form_id)
        if form_obj.user.id == current_user.id
            if form_obj.destroy
                flash[:notice] = "表单删除成功"
            else
                flash[:notice] = "表单删除失败"
            end
            redirect_to show_path
        end
    end

    def show
        form_name = params[:form_name]
        @forms = current_user.forms.where("name like ?","%#{form_name}%").order(created_at: :desc).page(params[:page]).per(5)
        @forms = @forms.where("start_at >= ?", params[:date_from]) if params[:date_from].present?
        @forms = @forms.where("end_at <= ?", params[:date_to]) if params[:date_to].present?
    end

    def edit
        if session[:new_form_id].present?
            @form_id = session[:new_form_id]
            session[:new_form_id]=nil
        else
            @form_id = params[:form_id].to_i
        end
        session[:form_id] = @form_id
        form = Form.find(@form_id)
        forms_list = []
        form.fileds.find_each do|filed|
            s = eval(filed.extra.to_s)
            forms_list.push(s)
        end
        @json_form= JSON.generate(forms_list)
    end

    def update
        form_obj = Form.find(session[:form_id])
        session[:form_id] = nil
        form_obj.fileds.find_each do|x|
            x.extra = nil
            x.save
        end
        filed_dates = params[:properties]
        filed_save(filed_dates,form_obj)
    end

    def fill
        form_takon = params[:form_takon]
        form = Form.find_by(takon:form_takon)
        if form.tag && Time.now < Time.parse(form.end_at) && Time.now > Time.parse(form.start_at)
          session[:form_takon] = form_takon
          forms_list = []
          form.fileds.find_each do|filed|
              s = eval(filed.extra.to_s)
              forms_list.push(s)
          end
          @form_name = form.name
          @json_form = JSON.generate(forms_list)
        else
          redirect_to root_path
        end
    end

    def save
        filed_dates = params[:properties]
        filed_dates = JSON.parse(filed_dates)
        form_obj = Form.find_by(takon: session[:form_takon])
        session[:form_id] = nil
        value_list = []
        filed_dates.each do|f|
            type = f["type"]
            must_in = f["required"]
            min = f["min"]
            max = f["max"]
            value = f["value"]
            subtype = f["subtype"]
            values = f["values"]
            if !values
                value_list.push(value)
            else
                values.each do|v|
                    if v["selected"]
                        value_list.push(v["value"])
                        value = v["value"]
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
                return unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            end
        end
        if signed_in?
            tmp = form_obj.form_users.new(user_id:current_user.id)
            tmp.save
        else
            tmp = form_obj.form_users.new(user_id:4)
            tmp.save
        end
        form_obj.fileds.each do|f|
            f.values.new(content:value_list[0],form_user_id:tmp.id).save
            value_list.delete_at(0)
        end
        flash[:notice] = "表单填写成功"
        redirect_to finish_fill_path
    end

    def finish_fill
        @forms = Form.where('start_at < ? and end_at > ? and tag ',Time.now,Time.now)[0..5]
    end
    def user_data
        form_id = params[:form_id]
        @fields = Filed.where(form_id: form_id)
        session[:form_id] = form_id
        select = " select u.id, u.name,f.id,f.created_at"
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
        value_id = params[:value_id].to_i
        if FormUser.find(value_id).destroy
            flash[:notice] = "数据删除成功！"
        else
            flash[:notice] = "数据删除失败！"
        end
        redirect_to "http://localhost:3000/userdata?form_id="+session[:form_id].to_s
    end

    def detail_form_user
        value_id = params[:value_id].to_i
        @values=FormUser.find(value_id).values
    end

    def stop
        form_takon = params[:form_takon]
        form = Form.find_by(takon:form_takon)
        form.update(tag:false)
        redirect_to show_path
    end

    def restart
        form_takon = params[:form_takon]
        form = Form.find_by(takon:form_takon)
        form.update(tag:true )
        redirect_to show_path
    end

    def csv
        form_user = FormUser.find(params[:value_id].to_i)
        values = form_user.values
        csv_string = CSV.generate do |csv|
            csv << ["表单名称",form_user.form.name]
            csv << ["填写者",form_user.user.name]
            csv << ["字段名","内容"]
            values.each do |v|
                csv << [v.filed.label,v.content]
            end
        end
        send_data csv_string, :type => 'text/csv; charset=utf-8', :filename => "#{form_user.form.name + "——" + form_user.user.name}.csv"
    end

    private
    def signed_confirmation
        if !signed_in?
            flash[:notice] = "请先登录!"
            redirect_to root_path
        end
    end

    def filed_save(filed_dates,form_obj)
        filed_dates = JSON.parse(filed_dates)
        form_obj.fileds.find_each do |x|
            x.destroy
        end
        filed_dates.each do |filed_date|
            filed_name = filed_date["name"]
            filed_label = filed_date["label"]
            filed_type = filed_date["type"]
            extra_data = filed_date
            if extra_data.has_key?("value")
                extra_data["value"]=nil
            end
            filed_obj = form_obj.fileds.build(name:filed_name,label:filed_label,f_type:filed_type,extra:extra_data).save
            flash[:notice] = "表单数据写入成功！"
        end
        redirect_to show_path
    end


end