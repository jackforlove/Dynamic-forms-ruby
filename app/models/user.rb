class User < ApplicationRecord
  has_many :forms,dependent: :destroy
  has_many :form_users
end
