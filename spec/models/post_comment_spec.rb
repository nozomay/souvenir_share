require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  #let(:comment){ build(:comment,user_id: user.id, post_id: post.id) }
  let(:post_comment){ create(:post_comment) }

  describe 'バリデーションのテスト' do

    context 'コメント成功のテスト' do
      it 'コメント文を入力済みであれば保存できる' do
        expect(post_comment).to be_valid
      end
    end

    context 'コメント失敗のテスト' do
      it 'コメントが空では投稿できない' do
        post_comment.comment = nil
        post_comment.valid?
        expect(post_comment.errors.full_messages).to include "Commentを入力してください"
      end
      it 'ユーザーがログインしていなければコメントできない' do
        post_comment.user_id = nil
        post_comment.valid?
      end
      it '投稿がないとコメントができない' do
        post_comment.post.id = nil
        post_comment.valid?
      end
    end
  end
end