class Filed < ApplicationRecord
    has_many :values,dependent: :destroy
    belongs_to :form
    validates :name ,presence:{message:"名字不能为空"}, length: {minimum:2, maximum:10,too_long: "名字过长",too_short:"名字过短"},uniqueness:{case_sensitive: false}
end
