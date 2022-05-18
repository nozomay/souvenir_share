require 'rails_helper'

RSpec.describe PostCommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  let(:comment) { FactoryBot.create(:comment) }
  
  describe '#create' do
    context '承認ユーザの場合' do
      it '正常に投稿を作成できるか' do
        sign_in user 
        expect {
          post :create, params: {
            comment: {
              user_id: 1,
              post_id: 1,
              comment: 'test'
            }
          }
        }.to change(user.post.comment, :count).by(1)
      end
      it '投稿完了後詳細ページへリダイレクトされるか' do
        sign_in user
        post :create, params: {
          comment: {
              user_id: 1,
              post_id: 1,
              comment: 'test'
          }
        }
        expect(response).to redirect_to "/posts/2"
      end
    end
    context '無効なアトリビュートの場合' do
      it '無効な投稿を作成しようとすると、投稿詳細ページへリダイレクトされる' do
        sign_in user
        comment :create, params: {
          comment: {
              user_id: 1,
              post_id: 1,
              comment: nil
          }
        }
        expect(response).to redirect_to "/posts/2"
      end
    end
    context 'ログインしていないユーザの場合' do
      it "302レスポンスが返ってくる" do
        get :create
        expect(response).to have_http_status "302"
      end
      it "ログイン画面にリダイレクトされる" do
        get :create
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  describe '#destroy' do
    context '承認ユーザの場合' do
      it '正常に記事を削除できる' do
        sign_in user
        expect {
          delete :destroy, params: {id: post.comment.id}
        }.to change(user.posts.comment, :count).by(-1)
      end
      it '投稿を削除した後、投稿一覧ページへリダイレクトされるか' do
        sign_in user
        delete :destroy, params: {id: post.comment.id}
        expect(response).to redirect_to post_path(post)
      end
    end
  end
end