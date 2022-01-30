class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  #[いいね]
  def favorited_by?(user)
    post_favorites.where(user_id: user.id).exists?
  end

  #[Google Map]
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  #[レビュースコア]星1以上〜５以下
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
