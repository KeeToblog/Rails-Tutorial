require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
    #assert_select 'div#<CSS id for error explanation>'
    #assert_select 'div.<CSS class for field with error>'
  end
  # assert_no_differenceメソッドは、ユーザー数を覚えた後にデータを投稿して、ユーザー数が変わらないかどうかのチェックをする。以下のコードと同値。
  # before_count = User.count
  # post users_path, ...
  # after_count  = User.count
  # assert_equal before_count, after_count
  # つまりassert_no.differenceメソッドはユーザー登録失敗時のテストなので、メソッド実行の前後でUser.countが変化しないでほしいということ。
  
  
  
# ユーザー登録成功時のテスト
    test "valid signup information" do
    get signup_path #/signupページを表示する
    assert_difference 'User.count', 1 do #ブロック内の処理の実行前後のUser.countの値を比較する。
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # usersコントローラーのcreateアクションをparamsを引用して実行する。
    follow_redirect!
    assert_template 'users/show' 
    #POSTリクエストを送信した結果を見て/users/showに飛ばす。Userのshowアクション、show.html.erbが正しく動かないとこのテストは成功しない。
    assert_not flash.empty?
    # flashが空ならfalse、埋まっていればtrueを返す。
  end
  # assert_differenceメソッドでは第二引数にメソッド実行後の差異（１）を渡す。ユーザー登録が成功すればUser.countが１増えるから。
  
end