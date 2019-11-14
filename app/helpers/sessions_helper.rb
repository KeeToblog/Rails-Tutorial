module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  
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
  
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  # 否定演算子「!」を使う。
  
end