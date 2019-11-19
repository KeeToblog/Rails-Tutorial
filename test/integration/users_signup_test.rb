require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  

# ユーザー登録失敗時のテスト
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  # assert_no_differenceメソッドは、ユーザー数を覚えた後にデータを投稿して、ユーザー数が変わらないかどうかのチェックをする。以下のコードと同値。
  # before_count = User.count
  # post users_path, ...
  # after_count  = User.count
  # assert_equal before_count, after_count
  # つまりassert_no.differenceメソッドはユーザー登録失敗時のテストなので、メソッド実行の前後でUser.countが変化しないでほしいということ。
  
  
  
# ユーザー登録成功時のテストとアカウントの有効化
  test "valid signup information with account activation" do
    get signup_path 
    # ユーザー新規登録ページ(/signup)を取得する
    assert_difference 'User.count', 1 do 
    # ブロック内の処理の実行前後のUser.countの値を比較する。assert_differenceメソッドでは第二引数にメソッド実行後の差異（１）を渡す。
    # ユーザー登録が成功すればUser.countが１増える
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # usersコントローラーのcreateアクションをparams（有効なユーザー情報）を引用してPOSTする。
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 配信されたメッセージがきっかり１つかどうか確認する（他のテストと衝突しないようにする）
    user = assigns(:user)
    # assignsメソッドで対応するアクション内のインスタンス変数(@user)にアクセスできる。今回の場合usersコントローラーのcreateアクションの@userを呼び出している。
    assert_not user.activated?
    # ユーザーが有効化されていたらfalse, 有効化されていなかったらtrueを返す。
    log_in_as(user)
    # 有効化されていないユーザーでログイン
    assert_not is_logged_in?
    # 一時セッションでログインできたらfalse,ログインできなかったらtrue（有効化されていないのでログインできない）
    
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # ログインできなかったらtrue
    
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # ログインできなかったらtrue
    
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    # メルアドとそれに対応する有効化トークンを引数として、account_activationコントローラーのeditアクションに渡し、正しく有効化する
    assert user.reload.activated?
    
    follow_redirect!
    # POSTリクエストを送信する（リダイレクト）
    assert_template 'users/show' 
    # POSTリクエストを送信した結果を見て/users/showに飛ばす。Userのshowアクション、show.html.erbが正しく動かないとこのテストは成功しない。
  # assert_not flash.empty?
    # flashが空ならfalse、埋まっていればtrueを返す。
    assert is_logged_in?
    # testヘルパーの確認。ユーザー登録の終わったユーザーがログイン状態になっているか確認する。
  end

  
end