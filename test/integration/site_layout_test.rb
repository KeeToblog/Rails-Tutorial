require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout_links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    get contact_path #contact_pathを呼び出せ。
    assert_select "title", full_title("Contact") # <title>タグ内にfull_title("Contact")があるかどうか。
  end
  # aタグでリファレンス（href）を呼び出し"?"は"root_path"などで置換される。homeにはリンク先が２つあるので"count: 2"で指定。
  # これにより<a href="root">...</a>のようなHTMLがあるかどうかをチェックできる。
end
