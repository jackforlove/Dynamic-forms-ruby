class Form < ApplicationRecord
    has_many :fileds,dependent: :destroy
    belongs_to :user
    validates :name ,presence:{message:"名字不能为空"}
end
