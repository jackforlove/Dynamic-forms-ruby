class Form < ApplicationRecord
    has_many :fileds,dependent: :destroy
    has_many :user_datums,dependent: :destroy
    belongs_to :user
    validates :name ,presence:{message:"名字不能为空"}
end
