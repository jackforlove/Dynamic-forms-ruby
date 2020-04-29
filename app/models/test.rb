class Test < ApplicationRecord
    has_many :papers,dependent: :destroy,autosave: true
    before_save :save_before
    validates :name ,presence:{message:"名字不能为空"}, length: {minimum:2, maximum:10,too_long: "名字过长",too_short:"名字过短"},uniqueness:{case_sensitive: false}
    validates :age,presence: {message:"年龄不能为空"},length: {in:1..3,too_long:"%{value} 年龄过大",too_short:"年龄过小"},numericality:{only_integer: true}
    private 
        def save_before
            puts "存储之前"
        end
end
