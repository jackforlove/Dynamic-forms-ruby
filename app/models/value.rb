class Value < ApplicationRecord
    belongs_to :filed
    validates :content ,presence:{message:"不能为空"}
    validates :userid,presence: true
end
