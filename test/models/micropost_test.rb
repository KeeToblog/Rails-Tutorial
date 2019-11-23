require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # fixturesのユーザー（michael）を@userに代入する
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    # このコードは慣習的に正しくない。上のようにUserモデルに関連づける
    # contentを"Lorem ipsum"、user_idをmichaelのユーザーIDとして引数にとり、マイクロポストを作成し、@micropostに代入する
  end

  # マイクロポストの有効性のテスト
  test "should be valid" do
    assert @micropost.valid?
    # @micropostが有効ならtrue, 無効ならfalseを返す（setupメソッドが有効ならtrueになる）
  end

  # user_idの存在性のテスト
  test "user id should be present" do
    @micropost.user_id = nil
    # michaelの@micropostが存在しないとする
    assert_not @micropost.valid?
    # @micropostが有効ならfalse, 無効ならtrueを返す。
  end
  
  # マイクロポストのcontentの存在性のテスト
  test "content should be present" do
    @micropost.content = "   "
    # contentが空白（存在していない）
    assert_not @micropost.valid?
    # @micropostが有効ならfalse, 無効ならtrueを返す。
  end

  # マイクロポストのcontentを140文字以内に収めるテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    # 文字列"aaaa...aaa"が141文字になる
    assert_not @micropost.valid?
    # @micropostが有効ならfalse, 無効ならtrueを返す。
  end
  
  
  # 最新のマイクロポストが先頭にくるようにするテスト
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
    # 
  end
  
end
