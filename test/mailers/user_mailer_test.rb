require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  # アカウント有効化用メイラーメソッドのテスト
  test "account_activation" do
    user = users(:michael)
    # fixtureユーザー（michael）をuserに代入
    user.activation_token = User.new_token
    # 有効化トークンをmichaelに追加する
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    # メール本文にユーザー名が含まれているか
    assert_match user.activation_token,   mail.body.encoded
    # メール本文に有効化トークンが含まれているか
    assert_match CGI.escape(user.email),  mail.body.encoded
    # CGI.escape(user.email)でテスト用のユーザーのメルアドもエスケープできる
  end
  # assert_matchメソッドは正規表現での文字列の一致もテストできる。
  
  
  # パスワード再設定用メイラーメソッドのテスト
  test "password_reset" do
    user = users(:michael)
    # michaelをローカル変数(user)に代入する
    user.reset_token = User.new_token
    # リセットトークンをmichaelに追加する
    mail = UserMailer.password_reset(user)
    # UserMailerクラスのpassword_reset(user)メソッドをmail属性に代入する
    assert_equal "Password reset", mail.subject
    # mailのタイトルがPassword resetと一致する
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
    # CGI.escape(user.email)でテスト用のユーザーのメルアドもエスケープできる
  end
  
  
  
end