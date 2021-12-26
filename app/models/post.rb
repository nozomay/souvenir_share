class Post < ApplicationRecord
  belongs_to :user
  
  #星1以上〜５以下
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
