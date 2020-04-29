class User < ApplicationRecord
  has_many :forms,dependent: :destroy
  

end
