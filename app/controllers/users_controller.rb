class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # onlyオプションを渡すことで、editとupdateアクションだけにこのフィルタが適用される。
  # 編集・更新をするときはログイン済みかどうかを確認する。
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  
  # indexアクションでUsersをページネートする
  def index
    @users = User.paginate(page: params[:page])
  end
  
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  # 新規ユーザーを登録するときform_forメソッドによってここにPOSTされる。
  def create
     # @user = User.new(params[:user])
     @user = User.new(user_params)
    # user_paramsはparams[:user]の代わりに使える外部メソッドで、適切に初期化したハッシュを返す。
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # redirect_to user_url(@user)と等価
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
  
  
  # 実際に動作するdestroyアクションを追加する
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  private
  # Rubyのprivateキーワードで外部から使えないようにする。
  
    def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # ストロングパラメーターを使うことで、必須のパラメータと許可されたパラメーターを指定できる。
    
    
    # ログイン済みユーザーかどうか確認
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
