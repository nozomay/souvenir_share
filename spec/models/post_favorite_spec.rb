require 'rails_helper'

RSpec.describe 'PostFavoritモデルのテスト', type: :model do
  let(:post_favorite) { build(:post_favorite) }
  
  describe 'バリデーションのテスト' do
    context 'いいねができる時' do
      it 'user_idとpost_idがあれば保存される' do
        expect(FactoryBot.create(:post_favorite)).to be_valid
      end
    end
    context 'いいねができない時' do
      it 'user_idがないと保存できない' do
        post_favorite.user = nil
        post_favorite.valid?
      end
      it 'post_idがないと保存できない' do
        post_favorite.post = nil
        post_favorite.valid?
      end
    end
  end
end