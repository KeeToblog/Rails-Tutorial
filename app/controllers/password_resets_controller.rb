class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  
  def new
  end
  
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # form_forメソッドによって送信のあと、paramsハッシュで受け取ったemail値を小文字化しemail属性に渡す。
    # DBから同じemail値を持つユーザーを取り出し、@userに代入する
    if @user
    # DBに一致するユーザーがいればtrue,いなければfalseを返す
      @user.create_reset_digest
      # リセットダイジェストを生成する
      @user.send_password_reset_email
      # パスワード再設定用のメールを送信する
      flash[:info] = "Email sent with password reset instructions"
      # flashメッセージが表示される
      redirect_to root_url
      # root_urlへリダイレクトする
    else
      flash.now[:danger] = "Email address not found"
      # flashメッセージが表示される
      render 'new'
      # Forgot passwordページ(/password_resets/new)を出力する
    end
  end
  
  

  def edit
  end
  
  # パスワードを更新する(パスワード変更ページ(/password_resets/:id)のform_forメソッドのPATCHリクエストを受け取る)
  def update
    if params[:user][:password].empty?
    # 新しいパスワードが空ならtrue, 埋まっていたらfalseを返す。
      @user.errors.add(:password, :blank)
      # @userのエラーメッセージを追加する。空の文字列に対するデフォルトのメッセージを表示する
      render 'edit'
      # パスワード再設定ページ(/password_resets/:id/edit)を表示する
    elsif @user.update_attributes(user_params)
    # ストロングパラメーターを受け取り、更新が成功したらtrueを返す。
      log_in @user
      # @userとしてログインする
      @user.update_attribute(:reset_digest, nil)
      # パスワードの再設定に成功したらreset_digestをnilに更新する。
      flash[:success] = "Password has been reset."
      redirect_to @user
      # ユーザー情報ページ(/users/:id)へリダイレクトする
    else
      render 'edit'
      # 無効なパスワードなら、パスワード再設定ページ(/password_resets/:id/edit)を表示する
    end
  end
  
  
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    # ストロングパラメーター。user属性を必須とし、passwordとpassword_confirmation属性は許可する。

    def get_user
      @user = User.find_by(email: params[:email])
      # paramsで受け取ったメルアドに対応するユーザーをDBから探し出し、@userに格納する。
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
      # @userがDBで確認できて、かつ有効化されており、かつパスワード再設定用トークン(reset_token)が認証されている(true)こと
        redirect_to root_url
      end
    end
    
    
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
      # パスワードの有効期限が切れていたらtrue, 切れていなかったらfalseを返す
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
        # パスワード再設定ページ(/password_resets/new)へリダイレクトする
      end
    end
    
    
end
