class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # セッションを実装するには、様々なコントローラーやビューで大量のメソッドを定義する必要がある。
  # Railsの全コントローラーの親クラスであるApplicationコントローラーにSessionヘルパーモジュールを読み込ませれば、どのコントローラーでも使えるようになる。
  def hello
    render html: "hello, world!"
  end
end
