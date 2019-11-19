require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
  end
  
  # ページネーションを含めたユーザー一覧ページ(/users)の表示を確認し、リンクを削除する
  test "index as admin including pagination and delete links" do
    log_in_as(@user)
    # michael(管理者）としてログインする
    get users_path
    # ユーザー一覧ページ(/users)を取得する
    assert_template 'users/index'
    # ユーザー一覧ページの表示を確認する。
    assert_select 'div.pagination', count: 2
    # paginationクラスを持ったdivタグ(indexビューのwill_paginate)をチェックする。
    first_page_of_users = User.paginate(page: 1)
    # ページネーションを含めたユーザー一覧ページの１ページ目をfirst_page_of_usersに代入する
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # 各ユーザーの名前を表示し、リンク先は各ユーザーjの編集ページ(/users/:id)
      unless user == @admin
        assert_select 'a[href=?]', user_path(user) #text: 'delete'
        # 管理者だったらdelete機能が使える。「textが１つ表示されるはずだが０」というエラーが出てテストをパスしない
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      # archer（非管理者）のユーザー編集ページ(/users/:id)を削除する。削除した後はユーザーの数が一つ減る
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end