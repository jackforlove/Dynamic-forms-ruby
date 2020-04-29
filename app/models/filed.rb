class Filed < ApplicationRecord
    has_many :values,dependent: :destroy
    belongs_to :form
    validates :name ,presence: true
end
