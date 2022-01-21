class Post < ApplicationRecord
  belongs_to :user
  
  attachment :image

  #[Google Map]
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  #[レビュースコア]星1以上〜５以下
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
