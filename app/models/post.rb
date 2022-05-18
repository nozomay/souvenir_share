class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags


  #[検索]
  def self.looks(content)
    @posts = Post.where(['title LIKE ? OR review LIKE ? OR address LIKE ?', "%#{content}%", "%#{content}%", "%#{content}%"])
  end
  
  #[タグ]
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    
      old_tags.each do |old_name|
        self.tags.delete Tag.find_by(name: old_name)
      end
  
      new_tags.each do |new_name|
        post_tag = Tag.find_or_create_by(name: new_name)
        self.tags << post_tag
      end
  end

  #[いいね]
  def favorited_by?(user)
    post_favorites.where(user_id: user.id).exists?
  end

  #[Google Map]
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  #[レビュースコア]星1以上〜５以下
  # validates :rate, numericality: {
  #   less_than_or_equal_to: 5,
  #   greater_than_or_equal_to: 1
  # }, presence: true
  
  validates :title, presence: true
  validates :review, presence: true
  validates :address, presence: true
end