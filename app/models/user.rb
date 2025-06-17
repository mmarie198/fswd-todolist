class User < ApplicationRecord
  
  has_many :tasks
  has_many :sessions

  validates :username, presence: true, length: { minimum: 3, maximum: 64 }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 } 
  validates_uniqueness_of :username
  
end
