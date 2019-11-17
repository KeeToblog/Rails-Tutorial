require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  # 編集失敗に対するテスト
  test "unsuccessful edit" do
    log_in_as(@user)
    # michaelとしてログインする
    get edit_user_path(@user)
    # ユーザー編集ページ(/users/:id/edit)にアクセスする
    assert_template 'users/edit'
    # 移動したページ(/users/:id/edit)が正しく表示されたか確認する
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    # わざと失敗するuserIDを引数として、patchメソッドを使ってPATCHリクエストを送信する。

    assert_template 'users/edit'
    # もう一度編集ページの表示を確認する
    assert_select "div.alert", "The form contains 4 errors."
    # 上記のuserIDではエラーが４つ出るはずなので、div.alertを呼び出し正しいエラーメッセージが出るか確認する。
  end
  
  
  # 編集成功に対するテスト（フレンドリーフォワーディング付き）
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    # ユーザー編集ページ(/users/:id/edit)にアクセスする
  # assert_equal session[:forwading_url], edit_user_url(@user)
    # 渡されたURLに転送されているか確認
    log_in_as(@user)
    # michaelとしてログイン
  # assert_nil session[:forwarding_url]
    # forwarding_urlの値がnilならtrue(deleteが効いている)
    assert_redirected_to edit_user_url(@user)
    # ユーザー編集ページ(/users/:id/edit)にリダイレクトする（ログインした後はここに飛ばしてあげる）
  # assert_template 'users/edit'（フレンドリーフォワーディングにより表示されなくなったのでコメントアウト）
    # 移動したページ(/users/:id/edit)が正しく表示されたか確認する。
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    # ユーザー名やメルアド編集で毎回パスワードを入力するのは面倒なので、入力せずに更新できるようにする。
    # 引数には成功するuserIDをPATCHリクエスト。（パスワード空はバリデーションの例外処理を追加して対応）
    assert_not flash.empty?
    # flashメッセージが空ならfalse, 埋まっていたらtrueを返す。
    assert_redirected_to @user
    # michaelのユーザーIDページへ移動できたらtrue
    @user.reload
    # DBから最新のユーザー情報を読み込み直す。
    assert_equal name,  @user.name
    # DB内の名前と@userの名前が一致していたらtrue
    assert_equal email, @user.email
    # DB内のEmailと@userの名前えが一致していたらtrue
  end
  
  
end
