class FormUser < ApplicationRecord
    belongs_to :user ,optional:true
    belongs_to :form
    has_many :values
end
