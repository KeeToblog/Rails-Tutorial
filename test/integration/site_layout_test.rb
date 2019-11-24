require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  # レイアウトリンクが正しく表示されたかのテスト
  test "layout_links" do
    get root_path
    # root_path(/)を取得する
    assert_template 'static_pages/home'
    # HOMEページ(static_pages/home)が正しく表示されたか確認する
    assert_select "a[href=?]", root_path, count: 2
    # HOMEページへのリンクが２つあるか確認する。以下のassert_selectも同様。
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    get contact_path 
    # contact_path(/contact)を取得
    assert_select "title", full_title("Contact") 
    # <title>タグ内にfull_title("Contact")があるかどうか。
  end
  # aタグでリファレンス（href）を呼び出し"?"は"root_path"などで置換される。homeにはリンク先が２つあるので"count: 2"で指定。
  # これにより<a href="root">...</a>のようなHTMLがあるかどうかをチェックできる。
  
  
  def setup
    @user = users(:michael)
  end
  
  # ホームページ用の統合テスト。ユーザーがログイン済みのときのレイアウト。
  test "layout links when logged in" do   
    log_in_as(@user)
    # michaelでログインする
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
  end
  
  # Homeページに統計情報が正しく入力されているかのテスト
  test "count relationships" do
    log_in_as(@user)
    # michaelでログインする
    get root_path
    # Homeページを取得する
    assert_match @user.active_relationships.count.to_s, response.body
    # Homeページのどこかしらにmichaelがフォローしているユーザーの数が確認できる
    assert_match @user.passive_relationships.count.to_s, response.body
    # Homeページのどこかしらにmichaelをフォローしているユーザーの数が確認できる
  end
  
  
end
