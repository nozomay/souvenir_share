require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'プロフィール編集のテスト' do
    before do
      visit edit_user_path(user)
    end
    context '更新成功をテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        @user_old_profile_image = nil
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        attach_file 'user[profile_image]', File.join(Rails.root, 'spec/fixtures/images/test.jpg')
        click_button '保存'
      end
      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'profile_imageが正しく更新される' do
        expect(user.reload.profile_image).not_to eq @user_old_profile_image
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '投稿画面のテスト' do
    before do

      new_post(post)
    end
    context '投稿成功のテスト' do
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(user.posts, :count).by(1)
      end

      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '投稿'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '編集成功のテスト' do
      before do
        @post_old_image = post.image
        @post_old_title = post.title
        @post_old_review = post.review
        @post_old_address = post.address
        @post_old_tag = post.tags.name
        edit_post(post)
        click_button '保存'
      end

      it 'imageが正しく更新される' do
        expect(post.reload.image).not_to eq @post_old_image
      end

      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'reviewが正しく更新される' do
        expect(post.reload.review).not_to eq @post_old_review
      end
      it 'addressが正しく更新される' do
        expect(post.reload.address).not_to eq @post_old_address
      end
      it 'tagが正しく更新される' do
        expect(post.reload.tags.name).not_to eq @post_old_tag
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe 'フォロー機能のテスト' do
    context 'ユーザーをフォロー、フォロー解除ができる' do
      before do
        visit user_path(other_user)
      end

      it 'other_userをフォローする'do
        click_on 'followings'
        expect(pege).to have_selector 'followers'
        expect(user.followed.count).to eq(1)
        expect(other_user.follower.count).to eq(1)
      end
      it 'other_userをフォロー解除する'do
        click_on 'followers'
        expect(pege).to have_selector 'followings'
        expect(user.followed.count).to eq(0)
        expect(other_user.follower.count).to eq(0)
      end
    end
  end

  describe 'いいね機能のテスト' do
    let(:favorite) { create(:favorite, user_id: user.id, post_id: post.id) }

    before do
      visit post_path(other_post)
    end

    context 'ユーザーが投稿にいいね、いいね解除できる' do

      it "いいねを押す" do
        click_link '♡0'
        expect(page).to have_selector '.favorite'
        expect(other_post.post_favorites.count).to eq(1)
      end
      it "いいねを解除する" do
        click_link '♡0'
        click_link '♥1'
        expect(page).to have_selector '.not_favorite'
        expect(other_post.post_favorites.count).to eq(0)
      end
    end
  end

  describe 'コメント機能のテスト' do
    let(:post_comment){create(:post_comment,user_id: user.id, post_id: post.id)}
    context '他のコメント成功のテスト' do
      before do
        visit post_path(other_post)
        fill_in 'post_comment[comment]', with: Faker::Lorem.characters(number: 10)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '送信する' }.to change(other_post.post_comments, :count).by(1)
      end

      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '送信する'
        expect(current_path).to eq '/posts/' + other_post.id.to_s
        #expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end
end