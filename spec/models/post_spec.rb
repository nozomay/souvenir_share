require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  let(:post) { FactoryBot.create(:post) }

  describe 'バリデーションのテスト' do

    it '画像が有効である' do
      expect(post.image.present?).to eq true
    end

    it '全てのパラメーターが揃っていれば保存ができる' do
      expect(post).to be_valid
    end
  end
end