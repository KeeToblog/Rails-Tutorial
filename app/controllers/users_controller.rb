class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
     # @user = User.new(params[:user])
     @user = User.new(user_params)
    # user_paramsはparams[:user]の代わりに使える外部メソッドで、適切に初期化したハッシュを返す。
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # redirect_to user_url(@user)と等価
    else
      render 'new'
    end
  end
  
  private
  # Rubyのprivateキーワードで外部から使えないようにする。
  
    def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # ストロングパラメーターを使うことで、必須のパラメータと許可されたパラメーターを指定できる。
  
end
