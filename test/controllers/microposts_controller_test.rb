require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
    # @micropostにfixtureファイルのorangeという投稿を代入する
  end

  # ログインしてなければcreateアクションができないテスト
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
    # アクションの前後で投稿数が変化しない
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
      # paramsに"Lorem ipsum"という投稿を渡して（入力して）、POSTリクエストを送信する。しかしできない。
    end
    assert_redirected_to login_url
    # ログインページにリダイレクトする
  end


  # ログインしてなければdestroyアクションができないテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
    # アクションの前後で投稿数が変化しない
      delete micropost_path(@micropost)
      # @micropostを引数にとって、destroyアクションをして、投稿を削除する。しかしできない。
    end
    assert_redirected_to login_url
    # ログインページにリダイレクトする
  end
  
  
  # 違うユーザーのマイクロポストを削除しようとしてもできないテスト
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    # michaelとしてログインする
    micropost = microposts(:ants)
    # 違うユーザー(archer)のantsという投稿をmicroposts属性にとり、ローカル変数micropostに代入する
    assert_no_difference 'Micropost.count' do
    # アクションの前後でmicropostの数が変化しない
      delete micropost_path(micropost)
      # micropost、つまりarcherの投稿を削除する。しかしできない
    end
    assert_redirected_to root_url
    # Homeページ(root_url)にリダイレクトする。
  end
  
end