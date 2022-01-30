class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :relationships, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  validates :name, presence: true
end
