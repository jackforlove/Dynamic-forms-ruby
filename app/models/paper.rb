class Paper < ApplicationRecord
    belongs_to :test
    validates :conetent, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
end
