require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    # usersはfictureのファイル名users.ymlを表し、:michaelはユーザ参照のためのキーを表す。
  end
  
  # 有効な情報を使ってユーザーログイン（レイアウトの変更）をテストする
  test "login with valid information followed by logout" do
    get login_path
    # ログイン用のパスを開く(/loginページを開く)
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    # セッション用パスに有効な情報(@user)をpostする（createアクション）
    assert is_logged_in?
    # is_logged_in?ヘルパーメソッドを使い、セッション中にユーザーがいるか確認する。
    assert_redirected_to @user
    # リダイレクト先が正しいかどうかチェックする
    follow_redirect!
    # そのページに実際に移動する。
    assert_template 'users/show'
    # 移動したページ(/users/:id)が正しく表示されたか確認する。
    assert_select "a[href=?]", login_path, count: 0
    # ログイン後にログイン用リンク(login_path)が表示されないことを確認。count: 0というオプションで渡したパターンに一致するリンクが０か確認する。
    assert_select "a[href=?]", logout_path
    # ログアウト用リンク(logout_path)が表示されていることを確認。
    assert_select "a[href=?]", user_path(@user)
    # プロフィール用リンク(/users/:id)が表示されていることを確認する
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  
  # このテストはloginページでログインできないときにフラッシュメッセージを表示するが、homeページに戻ってもフラッシュメッセージが消えないバグの対策のため。
  # 方針は「エラーをキャッチするテストを先に書いて、そのエラーが解決するようにコードを書くこと」
  test "login with invalid information" do
    get login_path
    # ログイン用のパスを開く(/loginページを開く)
    assert_template 'sessions/new'
    # 新しいセッションフォームが正しく表示されたことを確認する。
    post login_path, params: { session: { email: "", password: "" } }
    # わざと無効なparamsハッシュを使ってセッション用パスにpostする(createアクション)
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 新しいセッションのフォームが再表示され、フラッシュメッセージが追加されることを確認する。
    # フラッシュメッセージが空ならfalse, 表示されればtrueを返す。
    get root_path
    # rootパス(homeページ)に移動する。
    assert flash.empty?
    # フラッシュメッセージが空ならtrue, 表示されればfalseを返す。
  end
  
  # remember_meのチェックボックスがオンになっている場合のテスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # '1'なのでチェックボックスはオンにして、ログインする。
    assert_not_empty cookies['remember_token']
    # cookiesの値が記憶トークンと一致する（cookiesが空でない）ならtrue, 一致しない(cookiesが空)ならfalseを返す。
  end
  
  
  # remember_meのチェックボックスがオフになっている場合のテスト
  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
  
  
end