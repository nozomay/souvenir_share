FactoryBot.define do
  factory :post_favorite do
    user { post.user }
    association :post
  end
end