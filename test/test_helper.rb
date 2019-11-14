ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!
# この2行を設定すると[rails test]コマンドで色がつくようになる。

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  # test環境でもApplicationヘルパーを使えるようにする
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  # セッション中にユーザーがいる（空ではない）ならtrue, いない（空である）ならfalseを返す。

  # Add more helper methods to be used by all tests here...
end
