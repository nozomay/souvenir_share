module PostSupport
  def new_post(post)
    visit new_post_path
    attach_file 'post[image]', File.join(Rails.root, 'spec/fixtures/images/test.jpg')
    fill_in 'post[title]', with: Faker::Lorem.characters(number: 10)
    fill_in 'post[review]', with: Faker::Lorem.characters(number: 20)
    fill_in 'post[address]', with: Faker::Lorem.characters(number: 15)
    fill_in 'post[name]', with: Faker::Lorem.characters(number: 5)
  end

  def edit_post(post)
    #visit post_path(post)
    attach_file 'post[image]', File.join(Rails.root, 'spec/fixtures/images/test.jpg'), make_visible: true
    #attach_file 'post_image', 'spec/fixtures/images/test.jpg'
    fill_in 'post[title]', with: Faker::Lorem.characters(number: 15)
    fill_in 'post[review]', with: Faker::Lorem.characters(number: 25)
    fill_in 'post[address]', with: Faker::Lorem.characters(number: 20)
    fill_in 'post[name]', with: Faker::Lorem.characters(number: 3)
  end
end