require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーションのテスト' do
    
    it 'プロフィール画像が有効である' do
      expect(user.profile_image.present?).to eq true
    end
    
    it 'ニックネームがある場合は有効である' do
      expect(user).to be_valid
    end
    
    it '自己紹介文が200文字以下であれば有効である' do
      user.introduction = Faker::Lorem.characters(number: 200)
      expect(user).to be_valid
    end

    it 'ニックネームがnilの場合は無効である' do
      user.name = nil
      expect(user).to be_invalid
    end
  end
end
