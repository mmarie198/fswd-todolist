class Task < ApplicationRecord
  belongs_to :user
  
  validates :description, presence: true, length: { minimum: 1, maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }
end
