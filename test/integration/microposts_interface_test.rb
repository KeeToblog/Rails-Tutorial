require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    # michaelを引数にとってusers属性に渡し、@userに代入する
  end

  test "micropost interface" do
    log_in_as(@user)
    # michaelとしてログインする
    get root_path
    # Homeページ(/)の情報を取得する
    assert_select 'div.pagination'
    # Homeページにdivクラスのpaginationがあるか確認する
    assert_select 'input[type=file]'
    
    # 無効な送信
    assert_no_difference 'Micropost.count' do
    # アクションの前後でマイクロポストの数が変わらない
      post microposts_path, params: { micropost: { content: "" } }
      # 空白のcontent投稿、paramsに渡して、POSTリクエストを送信する。
    end
    assert_select 'div#error_explanation'
    # divクラスのerror_explanationがあるか確認する
    
    # 有効な送信
    content = "This micropost really ties the room together"
    # 有効なメッセージを書いてローカル変数contentに代入する
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
    # アクションの前後でマイクロポストの数が１つ増える
      post microposts_path, params: { micropost: { content: content, picture: picture } }
      # contentをparamsに渡して、POSTリクエストを送信する
    end
    assert assigns(:micropost).picture?
    # 
    #assert_redirected_to root_url
    # Homeページ(/)へリダイレクトする
    follow_redirect!
    # リダイレクトに失敗(false)したら、例外を返す。
    assert_match content, response.body
    # Homeページのどこかにcontentがあればマッチ(true)になる。
    
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    # Homeページに「a」という投稿をして、deleteテキストがあるか確認する
    first_micropost = @user.microposts.paginate(page: 1).first
    # michaelに紐づいたマイクロポストをページネートして、first_micropostに代入する
    assert_difference 'Micropost.count', -1 do
    # アクションの前後でマイクロポストの数が１つ減る
      delete micropost_path(first_micropost)
      # first_micropostを削除する
    end
    
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    # archerのユーザー情報ページ(/users/:id)を取得する
    assert_select 'a', text: 'delete', count: 0
    # 
  end
  
  # マイクロポストの投稿数のテスト
  test "micropost sidebar count" do
    log_in_as(@user)
    # michaelとしてログインする
    get root_path
    # Homeページ(/)の情報を取得する
    assert_match "#{@user.microposts.count} microposts", response.body
    # Homeページのどこかにマイクロポストの投稿数があればマッチ(true)になる
    
    
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    # 無投稿のユーザー(malory)をother_userに代入する
    log_in_as(other_user)
    # maloryでログインする
    get root_path
    # Homeページ(/)を取得する
    assert_match "0 microposts", response.body
    # Homeページのどこにも投稿がなければマッチ(true)になる
    other_user.microposts.create!(content: "A micropost")
    # content属性にA micropostを渡し、maloryに紐づいたマイクロポストを投稿する
    get root_path
    # Homeページ(/)を取得する
    assert_match "1 micropost", response.body
    # Homeページのどこかしらに1 micropstsが見つかれbマッチ(true)になる
  end
  

end