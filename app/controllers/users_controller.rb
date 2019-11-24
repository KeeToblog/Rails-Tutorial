class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  # onlyオプションを渡すことで、editとupdateアクションだけにこのフィルタが適用される。
  # 編集・更新をするときはログイン済みかどうかを確認する。
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  
  # indexアクションでUsersをページネートする。有効化されたユーザーのみ表示する。
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # 有効化された各ユーザーの情報ページ(/users/:id)のみ表示する。
  def show
    @user = User.find(params[:id])
    # paramsで:idを受け取り、@userに代入する
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
    # ユーザーが有効化されていなかったら(adctivatedがfalseなら)、root_urlへリダイレクトする
  end
  
  def new
    @user = User.new
  end
  
  # 新規ユーザーを登録するときform_forメソッドによってここにPOSTされる。アカウント有効化も要求する
  def create
     # @user = User.new(params[:user])
     @user = User.new(user_params)
    # user_paramsはparams[:user]の代わりに使える外部メソッドで、適切に初期化したハッシュを返す。
    if @user.save
      @user.send_activation_email
      # 入力されたメルアド宛に有効化のためのメッセージを送信（モデルに移動してリファクタリングした）
      flash[:info] = "Please check your email to activate your account."
      # flashメッセージが表示される
      redirect_to root_url
      # ホームページへリダイレクトする
    else
      render 'new'
    end
  end
  
  # ユーザーがユーザー自身のプロフィールを編集する
  def edit
  #  @user = User.find(params[:id])
  end
  # params[:id]でユーザーのIDは取り出せる
  
  
  # ユーザー情報を更新するときにform_forメソッドによってここにPATCHされる。
  def update
    # @user = User.find(params[:id])
    # DBからユーザーIDを探して@userに代入する
    if @user.update_attributes(user_params)
      # user_params（ストロングパラメーター）を受け取り、成功時には更新と保存を同時行う。失敗するとfalseを返す。
      flash[:success] = "Profile updated"
      # 成功時のflashメッセージを表示
      redirect_to @user
      # 
    else
      render 'edit'
    end
  end
  
  
  # 実際に動��するdestroyアクションを追加する
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  
  private
  # Rubyのprivateキーワードで外部から使えないようにする。
  
    def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # ストロングパラメーターを使うことで、必須のパラメータと許可されたパラメーターを指定できる。
    
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      # ユーザーIDを@userに代入する
      redirect_to(root_url) unless current_user?(@user)
      # @userと記憶トークンcookieに対応するユーザー(current_user)を比較して、失敗したらroot_urlへリダイレクト。root_urlに飛ばすことでflashメッセージを無くす。
      # 編集・更新の前のアクションなので、ログイン情報が保存されている永続的cookieと比較する。
    end
    
    
    # destroyアクションの前に管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    # 現在のユーザーが管理者でなかったらroot_urlへリダイレクトする。
  
end
