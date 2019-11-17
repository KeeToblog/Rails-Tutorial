require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  # ページネーションを含めたユーザー一覧ページ(/users)の表示を確認する
  test "index including pagination" do
    log_in_as(@user)
    # michaelとしてログインする
    get users_path
    # ユーザー一覧ページ(/users)を取得する
    assert_template 'users/index'
    # ユーザー一覧ページの表示を確認する。
    assert_select 'div.pagination', count: 2
    # paginationクラスを持ったdivタグ(indexビューのwill_paginate)をチェックする。
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
    # 最初のページにユーザーがいることを確認する。
  end
  
end
