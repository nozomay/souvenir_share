require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  
  describe '#index' do
    it '正常なレスポンスであるか' do
      sign_in user
      get :index
      expect(response).to be_success
    end
    it '200レスポンスが返ってくる' do
      sign_in user
      get :index
      expect(response).to have_http_status '200'
    end
  end
  
  describe '#show' do
    context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :show, params: {id: post.id}
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :show, params: {id: post.id}
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインしていないユーザの場合' do
      it '正常にレスポンスが返ってこない' do
        get :show, params: {id: post.id}
        expect(response).to_not be_success
      end
      it '302レスポンスが返ってくる' do
        get :show, params: {id: post.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :show, params: {id: post.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#new' do
    context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :new
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :new
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインしていないユーザの場合' do
      it '正常にレスポンスが返ってこない' do
        get :new
        expect(response).to_not be_success
      end
      it '302レスポンスが返ってくる' do
        get :new
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :new
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#create' do
    context '承認ユーザの場合' do
      it '正常に投稿を作成できるか' do
        sign_in user 
        expect {
          post :create, params: {
            post: {
              user_id: 1,
              image_id: 1,
              title: 'test',
              review: 'test-1',
              rate: 3,
              address: 'test-2'
            }
          }
        }.to change(user.posts, :count).by(1)
      end
      it '投稿完了後詳細ページへリダイレクトされるか' do
        sign_in user
        post :create, params: {
          post: {
              user_id: 1,
              image_id: 1,
              title: 'test',
              review: 'test-1',
              rate: 3,
              address: 'test-2'
          }
        }
        expect(response).to redirect_to "/posts/2"
      end
    end
    context '無効なアトリビュートの場合' do
      it '無効な投稿を作成しようとすると、再度作成ページへリダイレクトされる' do
        sign_in user
        post :create, params: {
          post: {
              user_id: 1,
              image_id: 1,
              title: 'test',
              review: 'test-1',
              rate: 3,
              address: nil
          }
        }
        expect(response).to redirect_to "/posts/new"
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
  
  describe '#edit' do
    context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :edit, params: {id: post.id}
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :edit, params: {id: post.id}
        expect(response).to have_http_status '200'
      end
    end
    context '許可されていないユーザの場合' do
      it '正常なレスポンスが返ってこない' do
        sign_in other_user
        get :edit, params: {id: post.id}
        expect(response).to_not be_success
      end
      it '他のユーザーが記事を編集しようとすると、ルートページへリダイレクトされる' do
        sign_in other_user
        get :edit, params: {id: post.id}
        expect(response).to redirect_to root_path
      end
    end
      
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        get :edit, params: {id: post.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :edit, params: {id: post.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#update' do
    context '承認ユーザの場合' do
      it '正常に投稿を更新できるか' do
        sign_in user
        post_params = {title: "テスト"}
        patch :update, params: {id: post.id, post: post_params}
        expect(post.reload.title).to eq "テスト"
      end
      it '更新後、更新した投稿詳細ページへリダイレクトするか' do
        sign_in user
        post_params = {title: "テスト"}
        patch :update, params: {id: post.id, post: post_params}
        expect(response).to redirect_to "/posts/1"
      end
    end
    context '無効なアトリビュートの場合' do
      it '無効な投稿は更新できない' do
        sign_in user
        post_params = {title: nil}
        patch :update, params: {id: post.id, post: post_params}
        expect(post.reload.title).to eq "test"
      end
      it '無効な投稿を更新しようとすると、再度更新ページへリダイレクトされる' do
        sign_in user
        post_params = {title: nil}
        patch :update, params: {id: post.id, post: post_params}
        expect(response).to redirect_to "/posts/1/edit"
      end
    end
    context '許可されていないユーザの場合' do
      it '正常なレスポンスが返ってこない' do
        sign_in other_user
        get :edit, params: {id: post.id}
        expect(response).to_not be_success
      end
      it '他のユーザーが記事を編集しようとすると、ルートページへリダイレクトされる' do
        sign_in other_user
        get :edit, params: {id: post.id}
        expect(response).to redirect_to root_path
      end
    end
      
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        post_params = {
              user_id: 1,
              image_id: 1,
              title: 'test',
              review: 'test-1',
              rate: 3,
              address: 'test-2'
          }
        patch :update, params: {id: post.id, post: post_params}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        post_params = {
              user_id: 1,
              image_id: 1,
              title: 'test',
              review: 'test-1',
              rate: 3,
              address: 'test-2'
          }
        patch :update, params: {id: post.id, post: post_params}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#destroy' do
    context '承認ユーザの場合' do
      it '正常に記事を削除できる' do
        sign_in user
        expect {
          delete :destroy, params: {id: post.id}
        }.to change(user.posts, :count).by(-1)
      end
      it '投稿を削除した後、投稿一覧ページへリダイレクトされるか' do
        sign_in user
        delete :destroy, params: {id: post.id}
        expect(response).to redirect_to posts_path
      end
    end
    context '許可されていないユーザの場合' do
      it '投稿したユーザーだけが、投稿を削除できる' do
        sign_in user
        other_post = other_user.posts.create(
          image_id: 1,
          title: 'TEST',
          review: "TEST-1",
          rate: 4,
          address: 'TEST-2'
        )
        expect {
          delete :destroy, params: {id: other_post.id}
        }.to_not change(other_user.posts, :count)
      end
      it '他のユーザが投稿を削除しようとすると、投稿一覧ページへリダイレクトされる' do
        sign_in user
        other_post = other_user.posts.create(
          image_id: 1,
          title: 'TEST',
          review: "TEST-1",
          rate: 4,
          address: 'TEST-2'
        )
        delete :destroy, params: {id: other_post.id}
        expect(response).to redirect_to posts_path
      end
    end
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        delete :destroy, params: {id: post.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        delete :destroy, params: {id: post.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end