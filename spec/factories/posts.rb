FactoryBot.define do
  factory :post do
    association :user
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/test.jpg')) }
    title { Faker::Lorem.characters(number: 5) }
    review { Faker::Lorem.characters(number: 20) }
    rate {'3'}
    address { Faker::Lorem.characters(number: 10) }
  end
end