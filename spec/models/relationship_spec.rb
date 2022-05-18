require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :madel do
  describe 'バリデーションのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:relationship) { user.relationships.build(followed_id: other_user.id) }
  
    context 'フォローができる時' do
      it '全てのパラメーターが揃っていれば保存ができる' do
        expect(relationship).to be_valid
      end
    end
      
    context 'フォローができない時' do
      it 'follower_idがnilの場合' do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end
      it 'followed_idがnilの場合' do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end