class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # セッションを実装するには、様々なコントローラーやビューで大量のメソッドを定義する必要がある。
  # Railsの全コントローラーの親クラスであるApplicationコントローラーにSessionヘルパーモジュールを読み込ませれば、どのコントローラーでも使えるようになる。
  
  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
      # ログインしていればfalse, ログインしていなければtrueを返す。
        store_location
        flash[:danger] = "Please log in."
        # ログイン要求のflashメッセージを表示
        redirect_to login_url
        # ログインページ(/login)へ飛ばす。
      end
    end
    # チュートリアル第13章でUsers_controllerから移転。より上位のコントローラーに渡すことで、Micropostsコントローラでも使えるようにする
    
end
