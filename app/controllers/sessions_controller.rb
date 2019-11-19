class SessionsController < ApplicationController
  
  def new
  end
  
  # ログインページ(/login)のf.submitアクションが実行されるとform_forメソッドによりここにPOSTされる。paramsで内容を受け取る。
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # paramsハッシュで受け取ったemail値を小文字化しemail属性に渡して、DBから同じemail値を持つユーザーを取り出し、@userに代入する
    if user && user.authenticate(params[:session][:password])
    # 入力されたメルアドがDBに存在し、かつ入力された（paramsハッシュで受け取った）パスワードと一致する(&&)と、trueを返す。（email値とpassword値のペアが一致？）
    # authenticateメソッドは引数に渡された文字列(パスワード)をハッシュ化した値と、DB内にあるpassword_digest(こちらもハッシュ化された値)と比較する。
    # 間違ったパスワードを与えるとauthenticateメソッドはfalseを返す。
      if user.activated?
      # userが有効化されればtrue, 有効かされてなかったらfalseを返す
        log_in user
        # sessionメソッドのuser_idにidを送る（一時cookieとして保存）
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # remember_meのチェックボックスがオンのとき'1', オフのとき'0'になる。
        # ログインのときに'1'ならセッションを永続的に、それ以外なら永続的セッションを破棄する
        # 三項演算子の適用
        # if params[:session][:remember_me] == '1'
        #   remember(user)
        # else
        #   forget(user)
        # end
        redirect_back_or user
        # userの前のページもしくはdefault(user)にリダイレクト
        # redirect_to user
        #redirect_to user_url(user)と同じ。/users/:idにリダイレクトする。
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      # ユーザーが有効化されてなかったら、root_urlにリダイレクトし、「有効化しろ」メッセージを表示する
    else
      flash.now[:danger] = 'Invalid email/password combination' 
      # flash.nowのメッセージはその後のリクエスストが発生したときに消滅する。（テストの内容がまさにそれを再現）
      render 'new'
      # パスワードが一致しないとき、newビュー(/login)が出力される。
      # renderで表示したテンプレート（ビュー）はリクエストとみなされない。（だからflashのままだとメッセージが消えない）
    end
  end

  
  def destroy
    log_out if logged_in?
    # sessionsヘルパーの代入(log_out, logged_in?)。
    # ログイン中のユーザーがいる(logged_in?がtrue)場合のみログアウト(log_out)する。
    redirect_to root_url
    # root_urlに渡してホームページ(/)に戻る。
  end

end
