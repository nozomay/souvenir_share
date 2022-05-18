require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  
  describe '#create' do
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
  describe '#destro' do
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