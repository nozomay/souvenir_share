require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  
  describe '#show' do
    context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :show, params: {id: user.id}
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :show, params: {id: user.id}
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインしていないユーザの場合' do
      it '正常にレスポンスが返ってこない' do
        get :show, params: {id: user.id}
        expect(response).to_not be_success
      end
      it '302レスポンスが返ってくる' do
        get :show, params: {id: user.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :show, params: {id: user.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#edit' do
    context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :edit, params: {id: user.id}
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :edit, params: {id: user.id}
        expect(response).to have_http_status '200'
      end
    end
    context '許可されていないユーザの場合' do
      it '正常なレスポンスが返ってこない' do
        sign_in other_user
        get :edit, params: {id: user.id}
        expect(response).to_not be_success
      end
      it '他のユーザーが記事を編集しようとすると、ルートページへリダイレクトされる' do
        sign_in other_user
        get :edit, params: {id: user.id}
        expect(response).to redirect_to root_path
      end
    end
    
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        get :edit, params: {id: user.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :edit, params: {id: user.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#update' do
    context '承認ユーザの場合' do
      it '正常にマイページを更新できるか' do
        sign_in user
        user_params = {name: "user1"}
        patch :update, params: {id: user.id, user: user_params}
        expect(user.reload.name).to eq "user1"
      end
      it '更新後、更新したマイページへリダイレクトするか' do
        sign_in user
        user_params = {name: "user1"}
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to redirect_to "/users/" + user.id.to_s
      end
    end
    context '無効なアトリビュートの場合' do
      it '無効なマイページは更新できない' do
        sign_in user
        user_params = {name: nil}
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to have_content '1件のエラーが発生しました Nameを入力してください'
      end
      it '無効なマイページを更新しようとすると、再度編集ページへリダイレクトされる' do
        sign_in user
        user_params = {name: nil}
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to render "/users/" + user.id.to_s + "/edit"
      end
    end
    context '許可されていないユーザの場合' do
      it '正常なレスポンスが返ってこない' do
        sign_in other_user
        get :edit, params: {id: user.id}
        expect(response).to_not be_success
      end
      it '他のユーザがマイページを編集しようとすると、ルートページへリダイレクトされる' do
        sign_in other_user
        get :edit, params: {id: user.id}
        expect(response).to redirect_to root_path
      end
    end
      
    context 'ログインしていないユーザの場合' do
      it '302レスポンスが返ってくる' do
        user_params = {
              user_id: 1,
              profile_image_id: 1,
              name: 'user1',
              introduction: 'test'
          }
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        user_params = {
              user_id: 1,
              profile_image_id: 1,
              name: 'user1',
              introduction: 'test'
          }
        patch :update, params: {id: user.id, user: user_params}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  
  describe '#favorites' do
     context '承認ユーザの場合' do
      it '正常なレスポンスであるか' do
        sign_in user
        get :favorites, params: {id: user.id}
        expect(response).to be_success
      end
      it '200レスポンスが返ってくる' do
        sign_in user
        get :favorites, params: {id: user.id}
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインしていないユーザの場合' do
      it '正常にレスポンスが返ってこない' do
        get :favorites, params: {id: user.id}
        expect(response).to_not be_success
      end
      it '302レスポンスが返ってくる' do
        get :favorites, params: {id: user.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされる' do
        get :favorites, params: {id: user.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end