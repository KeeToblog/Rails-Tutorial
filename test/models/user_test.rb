require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  # valid?というメソッドは、モデル（ActiveRecord）のメソッド。バリデーションを実行して、モデルが正しい値かどうかを調べる。
  
  # Userオブジェクトの有効性のテスト
  test "should be valid" do
    assert @user.valid?
    # @userが有効ならtrue, 無効ならfalseになる。
  end

  
  # name属性の存在性のテスト
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
    # @userが有効ならfalse, 無効ならtrueを返す
  end
  # ユーザーの名前が空白（有効）ならfalse。つまり有効な名前が入力されないとテストが通らない。
  
  # email属性の存在性のテスト
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  # name属性の長さのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
    # 文字列が50文字以内ならtrue,そうでないならfalseを返す。
  end

  # email属性の長さのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
    # 文字列が255文字以内ならtrue,そうでないならfalseを返す。
  end

  
  # 有効なメールフォーマットのテスト
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    # 有効なメルアド群をvalide_addressesに代入する
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # valid_addressをユーザーのemail属性に代入する
      assert @user.valid?, "#{valid_address.inspect} should be valid"
      # ユーザーが有効ならtrueを返し、引数を呼び出したメッセージが表示される。
    end
  end

  
  # 無効なメールフォーマットのテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com, foo@bar..com]
    # 無効なメルアド群をinvalid_addressesに代入する
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # invalid_addressをユーザーのemail属性に代入する
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
      # ユーザーが無効ならtrueを返し、引数を呼び出したメッセージが表示される。
    end
  end


  # メルアドが固有のものかどうかのテスト
  test "email addresses should be unique" do
    duplicate_user = @user.dup 
    # dupは同じ属性を持つデータを複製するメソッド。duplicate_user属性に代入する
    duplicate_user.email = @user.email.upcase 
    # さらにupcaseメソッドで大文字に変換したメルアドも複製する。
    @user.save
    assert_not duplicate_user.valid?
    # duplicate_userが真ならfalse, 偽ならtrueを返す。つまり同じメルアドのユーザーは作成できなくなる。
  end
  
  # メルアドを小文字にするテスト。
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  # @user.saveが実行される前にmodels/usr.rbで定義したbefore_saveメソッドによって全ての文字が小文字に変換される。
  # assert_equalメソッドは値が一致しているかどうか確認する。
  # reloadメソッドはデータベースの値に合わせて更新する。
  
  
  # 空白６文字のパスワードだと弾かれるテスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # ５文字のパスワードだと弾かれるテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    # パスワードとパスワード確認に対して同時に代入している。
    assert_not @user.valid?
  end

  
  # 記憶ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  # authenticated?('')メソッド（記憶トークンが空）が真ならfalse, 偽ならtrueを返す（テストをパスする）。
  
  
  # ユーザーが削除されたら、それに紐づいたマイクロポストも削除されるかのテスト
  test "associated microposts should be destroyed" do
    @user.save
    # 有効なユーザーを保存
    @user.microposts.create!(content: "Lorem ipsum")
    # @userに紐づいたマイクロポストを作成。内容（content）はLorem ipsumと記載
    assert_difference 'Micropost.count', -1 do
      @user.destroy
      # @userを削除する。削除したあとはマイクロポストの数が一つ減る。
    end
  end
  
  # 「フォローする・フォロー解除する」のテスト
  test "should follow and unfollow a user" do
    michael = users(:michael)
    # fixturesファイルのmichaelを引数にして、ローカル変数michaelに代入する
    archer  = users(:archer)
    # fixturesファイルのarcherを引数にして、ローカル変数archerに代入する
    assert_not michael.following?(archer)
    # michaelがarcherをフォローしていたらfalse, していなかったらtrueを返す。
    michael.follow(archer)
    # michaelがarcherをフォローする
    assert michael.following?(archer)
    # michaelがarcherをフォローしていたらtrue, していなかったらfalseを返す。
    assert archer.followers.include?(michael)
    # archerのフォロワーにmichaelが含まれていたらtrue,していなかったらfalseを返す。
    michael.unfollow(archer)
    # michaelがarcherのフォローを解除する
    assert_not michael.following?(archer)
    # michaelがarcherをフォローしていたらfalse, していなかったらtrueを返す。
  end
  
  # ステータスフィードのテスト
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
  
  
end
