require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @non_activated_user = users(:non_activated)
  end
  
  # indexアクションのリダイレクトをテストする
  test "should redirect index when not logged in" do
    get users_path
    # ユーザー一覧ページ(/users)を取得。usersコントローラーのindexアクション。
    assert_redirected_to login_url
    # ログインページ(/login)へリダイレクトできたらtrue
  end
  
  
  test "should get new" do
    #get users_new_url
    get signup_path
    assert_response :success
  end
  
  
  # 間違ったユーザーが編集しようとしたらHPにリダイレクトする
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    # archerでログインする
    get edit_user_path(@user)
    # michaelのユーザー編集ページ(/users/:id/edit)へ飛ぶ
    assert flash.empty?
    # flashメッセージが空ならtrue, 埋まっていたらfalseを返す。
    assert_redirected_to root_url
    # root_URL(/)へリダイレクトする。
  end


  # 間違ったユーザーが更新しようとしたらHPにリダイレクトする
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    # archerでログインする
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # michaelのページ(users/:id)へ、フォームに入力したname.email値をPATCHリクエスト（更新）を送信。
    assert flash.empty?
    # flashメッセージが空ならtrue, 埋まっていたらfalseを返す。
    assert_redirected_to root_url
    # root_URL(/)へリダイレクトする。
  end
  
  
  # Web経由でadmin属性の変更が禁止されていることをテストする
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    # archerでログインする
    assert_not @other_user.admin?
    # archerがadminならfalse, adminでないならtrueを返す
    patch user_path(@other_user), params: {
                                    user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    # archerのページ(users/:id)へ、フォームに入力したpassword, password_confirmation, admin値をPATCHリクエスト（更新）を送信。
    assert_not @other_user.reload.admin?
    # archerを再読み込みし、admin論理値が変更されてないか検証（falseやnilならtrue）
  end
  
  
  # ユーザーがログインしていなければ、ログイン画面にリダイレクトする。
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
    # ユーザーの数がアクションの前後で変化しないことを確認する
      delete user_path(@user)
      # michaelのユーザー情報を削除する（できない）
    end
    assert_redirected_to login_url
    # login_url(/login)にリダイレクトする
  end


  # 管理者でないユーザーなら、ホーム画面にリダイレクトする
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    # archaerとしてログインする（管理者ではない）
    assert_no_difference 'User.count' do
    # ユーザーの数がアクションの前後で変化しないことを確認する
      delete user_path(@user)
      # michaelのユーザー情報を削除する（できない）
    end
    assert_redirected_to root_url
    # root_url(/)、つまりホーム画面にリダイレクトする
  end
  
  
  # 非有効化ユーザーはユーザー一覧ページ(/users)に表示しない
  test "should not allow the not activated attribute" do
    log_in_as(@non_activated_user)
    # 非有効化ユーザーでログインする
  #  assert_not @non_activated_user.activated?
    # 有効化されていたらfalse,有効化されていなかったらtrueを返す
    get users_path
    # users_path(/users)を取得する
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    # 非有効化ユーザーの情報ページ(/users/:id)へのリンクが表示されないことを確認
    get user_path(@non_activated_user)
    # 非有効化ユーザーの情報ページ(/users/:id)を取得する
    assert_redirected_to root_url
    # 有効化されていないので、root_urlへリダイレクトされるはず
  end

end
