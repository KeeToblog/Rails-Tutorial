require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    # @userにmichaelを代入する
  end

  test "profile display" do
    get user_path(@user)
    # ユーザー情報ページ(/users/:id)を取得する
    assert_template 'users/show'
    # ユーザー情報ページの表示を確認する
    assert_select 'title', full_title(@user.name)
    # タブのタイトルに@userのname属性を引数にとったfull_titleが表示されているか確認する
    assert_select 'h1', text: @user.name
    # 見出し(h1)に@userのname属性が表示されているか確認する
    assert_select 'h1>img.gravatar'
    # 見出し(h1)にgravetarクラス付きのimaタグがあるか確認する
    assert_match @user.microposts.count.to_s, response.body
    # ユーザーのマイクロポストの投稿数が存在すれば、探し出してマッチするか確認する。response.bodyにはそのページの完全なHTMLが含まれている。
    assert_select 'div.pagination', count: 1
    # divタグにpaginationが１つあるか確認する
    @user.microposts.paginate(page: 1).each do |micropost|
    # @userに紐づいたマイクロポストをページネーションして並べる
      assert_match micropost.content, response.body
      # マイクロポストの投稿が存在すれば、探し出してマッチするか確認する。
    end
  end
end