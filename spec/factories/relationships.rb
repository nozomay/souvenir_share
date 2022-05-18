FactoryBot.define do
  factory :relationship do
    #user { post.user }
    follower_id { FactoryBot.create(:user).id }
    followed_id { FactoryBot.create(:user).id }
  end
end