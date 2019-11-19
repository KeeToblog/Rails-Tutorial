require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

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
end