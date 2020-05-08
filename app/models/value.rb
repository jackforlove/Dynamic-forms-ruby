class Value < ApplicationRecord
    belongs_to :filed
    belongs_to :form_user
    validates :content ,presence:{message:"不能为空"}
end
