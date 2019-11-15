module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのセッションを永続的にする。cookiesの設定をする
  def remember(user)
    user.remember
    # Userモデルのrememberメソッドを使う。
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # ユーザーIDを安全に保存するために署名付きcookieを使う。
  # またユーザーIDと記憶トークンはペアで扱う必要があるためcookieを永続化する。
  
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  # 下記コードと等価である。
  # if @current_user.nil?　
  #  @current_user = User.find_by(id: session[:user_id])
  # else
  #  @current_user
  # end
  # セッションにユーザーIDが存在すればfalse, 存在しない(nil)ならtrueを返す。
  # つまり変数（@current_user）がnilなら変数に代入し、nilでなければ代入しない(変数の値を変えない)。
  # User.find_byの結果をインスタンス変数に保存することで、DBへのアクセスが最初の１回だけになり、処理が高速化できる。
  
  
# 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])                                            
    # 一時的なセッションユーザーがいる場合処理を行い、user_idに代入
      @current_user ||= User.find_by(id: user_id)                               
      # 現在のユーザーがいればそのまま、いなければsessionユーザーidと同じidを持つユーザーをDBから探して@current_user（現在のログインユーザー）に代入
    elsif (user_id = cookies.signed[:user_id])                                  
    # user_idを暗号化した永続的なユーザーがいる（cookiesがある）場合処理を行い、user_idに代入
      user = User.find_by(id: user_id)                                          
      # 暗号化したユーザーidと同じユーザーidをもつユーザーをDBから探し、userに代入
      if user && user.authenticated?(cookies[:remember_token])                  
        # DBのユーザーがいるかつ、受け取った記憶トークンをハッシュ化した記憶ダイジェストを持つユーザーがいる場合処理を行う
        log_in user                                                             
        # 一致したユーザーでログインする
        @current_user = user                                                    
        # 現在のユーザーに一致したユーザーを設定
      end
    end
  end
  
  

  
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  # 否定演算子「!」を使う。
  
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    # userモデルのforgetメソッドを呼び出す。記憶ダイジェストをnilで更新
    cookies.delete(:user_id)
    # user_idのcookiesを削除
    cookies.delete(:remember_token)
    # 記憶トークンのcookiesを削除
  end
  
  
    # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # 一時セッションのユーザーIDを削除する
    @current_user = nil
    # 現在のユーザーをnilにするs
  end
  
end