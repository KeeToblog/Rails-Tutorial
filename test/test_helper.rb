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
  
  
  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
    # sessionメソッドを直接操作して、:user_idキーにuser.idの値を代入する。
  end
  

end

# 統合テスト用のヘルパー
class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
  # 統合テストではsessionメソッドを直接取り扱えないので、代わりにSessionsリソースに対してpostを送信することで代用する。
  
end
