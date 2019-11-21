require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    # パスワード再設定ページ(/password_resets/new)を取得する
    assert_template 'password_resets/new'
    # パスワード再設定ページが表示されたか確認する
    
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    # 無効なメルアドを引数にしてparamsで受け取り、form_forメソッドのcreateアクションでPOSTリクエストを送信
    assert_not flash.empty?
    # flashメッセージが空ならfalse, 埋まっていたらtrueを返す。（エラーなのでメッセージはある）
    assert_template 'password_resets/new'
    # パスワード再設定ページ(/password_resets/new)を取得する
    
    # メールアドレスが有効
    post password_resets_path, params: { password_reset: { email: @user.email } }
    # michael（有効なユーザー）のメルアドを引数にする
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # 元々DBにあったreset_digestとPOSTリクエストの結果再設定されたreset_digestが異なればtrueを返す
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 配信されるメールが１つであるかどうか
    assert_not flash.empty?
    # flashメッセージが空ならfalse, 埋まっていたらtrueを返す。（再設定用メール送信のメッセージが表示）
    assert_redirected_to root_url
    # root_urlへリダイレクトされる
    
    
    # パスワード変更フォームのテスト（リセットトークンをメールで受け取りリンク先に飛ぶ）
    user = assigns(:user)
    # assignsメソッドで対応するアクション内のインスタンス変数にアクセスできる。（この場合createアクション？）
    
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    # パスワード変更フォーム(/password_resets/:id/edit)を取得。メルアドが無効。
    assert_redirected_to root_url
    # root_urlへリダイレクトされる
    
    # 無効なユーザー
    user.toggle!(:activated)
    # toggle!メソッドでactivated属性の状態をfalseからtrueに反転させる。つまり無効なユーザーならtrueを返す
    get edit_password_reset_path(user.reset_token, email: user.email)
    # パスワード変更フォーム(/password_resets/:id/edit)を取得。emailをキーとしてリセットトークンを取得してるが、今回はユーザーが無効。
    assert_redirected_to root_url
    # root_urlにリダイレクトする
    
    user.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    # パスワード変更フォーム(/password_resets/:id/edit)を取得。リセットトークンが無効。
    assert_redirected_to root_url
    # root_urlへリダイレクトする
    
    
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    # emailをキーとしてリセットトークンを取得。ユーザーも有効なのでパスワード変更フォーム(/password_resets/:id/edit)を正しく取得できる。
    assert_template 'password_resets/edit'
    # パスワード変更フォームが表示されたか確認する
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # inputタグに正しい名前、type="hidden"、メルアドがあるかどうか確認する
    
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    # パスワード変更フォームのform_forメソッドでPATCHリクエストを送信する。無効なパスワードと入力
    assert_select 'div#error_explanation'
    
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    # 空のパスワードを引数にしてparamsに渡し、PATCHリクエストを送信する。
    assert_select 'div#error_explanation'
    
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    # 有効なパスワードを引数にしてparamsに渡し、PATCHリクエストを送信
    assert_nil user.reload.reset_digest
    # PATCHリクエストをreset_digestを
    assert is_logged_in?
    # ユーザーがログインできたらtrueを返す。
    assert_not flash.empty?
    # flashメッセージが空ならfalse, 埋まっていたらtrueを返す。(Password has been reset.と表示される)
    assert_redirected_to user
    # ユーザー情報ページ(/users/:id)へリダイレクトされたか確認する
  end
  
  
  
  # パスワード再設定の期限切れのテスト
  test "expired token" do
    get new_password_reset_path
    # パスワード再設定ページ(/password_resets/new)を取得する
    post password_resets_path, params: { password_reset: { email: @user.email } }
    # 
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
  
  
  
  
  
end