require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  # valid?というメソッドは、モデル（ActiveRecord）のメソッド。バリデーションを実行して、モデルが正しい値かどうかを調べる。
  
  test "should be valid" do
    assert @user.valid?
  end
  # Userオブジェクトの有効性のテスト。
  # @userが真ならtrue, 偽ならfalseになる。
  
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  # 存在性のテスト。DBに保存される前に渡されたname属性が存在するかをチェックする。
  # @userが真ならfalse, 偽ならtrueになる。この場合ユーザーの名前が空白ならfalseを返して、名前があればtrueということ。
  
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  # 長さのテスト。文字列が51文字ならfalse,そうでないならtrueを返す。
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  # 有効なメールフォーマットをテストする。有効（true）なら、引数を呼び出したメッセージが表示される。
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com, foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  # 無効なメルアドを定義して、無効になるかをテストする。@userが真ならfalse,偽ならtrueになる。
  # 
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup #dupは同じ属性を持つデータを複製するメソッド。
    duplicate_user.email = @user.email.upcase #さらにupcaseメソッドで大文字に変換したメルアドも複製する。
    @user.save
    assert_not duplicate_user.valid?
  end
  # duplicate_userが真ならfalse, 偽ならtrueを返す。つまり同じメルアドのユーザーは作成できなくなる。
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  # メルアドを小文字にするテスト。
  # @user.saveが実行される前にmodels/usr.rbで定義したbefore_saveメソッドによって全ての文字が小文字に変換される。
  # assert_equalメソッドは値が一致しているかどうか確認する。
  # reloadメソッドはデータベースの値に合わせて更新する。
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  # 空白６文字だと弾かれる。

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  # パスワードとパスワード確認に対して同時に代入している。
  # 5文字だと弾かれる。
  
  
  # 記憶ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  # authenticated?('')メソッド（記憶トークンが空）が真ならfalse, 偽ならtrueを返す（テストをパスする）。
  
end
