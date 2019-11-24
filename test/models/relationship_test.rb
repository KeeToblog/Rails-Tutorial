require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id, followed_id: users(:archer).id)
    # michaelがarcherをフォローする、という関係をつくり、@relationshipに代入する
  end

  # 有効性のテスト
  test "should be valid" do
    assert @relationship.valid?
  end

  # フォロワーがnilだと無効になるテスト
  test "should require a follower_id" do
    @relationship.follower_id = nil
    # @relationship属性のfollower_idにnilを代入
    assert_not @relationship.valid?
    # @relationshipが有効ならfalse,無効ならtrueを返す
  end

  # 
  test "should require a followed_id" do
    @relationship.followed_id = nil
    # @relationship属性のfollowed_idにnilを代入
    assert_not @relationship.valid?
    # @relationshipが有効ならfalse,無効ならtrueを返す
  end
  
end
