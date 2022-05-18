FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number:5) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number:30) }
    password { 'password' }
    password_confirmation { 'password' }
    profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/test.jpg')) }
    # after(:build) do |user|
    #   user.profile_image.attach(io: File.open('spec/fixtures/images/test.jpg'), filename: 'test.jpg', content_type: 'image/jpg')
    # end
  end
end