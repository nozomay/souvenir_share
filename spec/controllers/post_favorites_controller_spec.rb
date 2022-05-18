require 'rails_helper'

RSpec.describe PostFavoritesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:favorite) { FactoryBot.create(:post_favorite) }
  let(:other_favorite) { FactoryBot.create(:post_favorite) }
  
  describe '#create' do
    context '承認ユーザの場合' do
      it '正常にいいねができるか' do
        sign_in user
        expect {
          post :create, params: {
            post_id: 1,
            user_id: 1
          }
        }.to change(user.post.favorite, :count).by(1)
      end
      it 'いいね後詳細ページへリダイレクトされるか' do
        sign_in user
        expect {
          post :create, params: {
            post_id: 1,
            user_id: 1
          }
        }
        expect(response).to redirect_to "/posts/" + post.id.to_s
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
      it 'いいねを取り消すことができる' do
        sign_in user
        expect {
          delete :destroy, params: {id: favorite.id}
        }.to change(user.post.favorites, :count).by(-1)
      end
      it 'いいねを取り消した後、投稿詳細ページへリダイレクトされるか' do
        sign_in user
        delete :destroy, params: {id: favorite.id}
        expect(response).to redirect_to post_path(post)
      end
    end
    context '許可されていないユーザの場合' do
      it '投稿したユーザーだけが、投稿を削除できる' do
        sign_in user
        other_favorite = other_user.favorites.create(
          post_id: 1,
          user_id: 1
        )
        expect {
          delete :destroy, params: {id: other_favorite.id}
        }.to_not change(other_user.favorite, :count)
      end
    end
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        delete :destroy, params: {id: favorite.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        delete :destroy, params: {id: favorite.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end