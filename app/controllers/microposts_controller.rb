class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy



  def create
    @micropost = current_user.microposts.build(micropost_params)
    # ストロングパラメーター(micropost_params)を引数にとり現在ログインしているユーザーでマイクロポストを作成し、@micropostに代入する
    if @micropost.save
    # @micropostを保存できたらtrue,できなかったらfalseを返す
      flash[:success] = "Micropost created!"
      # flashメッセージを表示する
      redirect_to root_url
      # root_url(/)へリダイレクトする
    else
      @feed_items = []
      # 投稿ページが空っぽ
      render 'static_pages/home'
      # ホームページ(/)を表示する
    end
  end



  def destroy
    @micropost.destroy
    # マイクロポストを削除する
    flash[:success] = "Micropost deleted"
    # flaashメッセージを表示する
    redirect_to request.referrer || root_url
    # request.referrerメソッドで、一つ前のURLを返す。今回の場合Homeページ(root_url)。
    # ||演算子でroot_urlをデフォルトに設定しているため、元に戻すURLが見つからなくてもOK
  end



  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    # ストロングパラメーターにより、micropostのcontent属性だけがWeb経由で変更可能になっている
    
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      # 現在ログインしているユーザーと一致するユーザーIDをDBから探す。いたらそのユーザーと投稿を紐付けて、@micropostに代入する
      redirect_to root_url if @micropost.nil?
      # @micropostに何も入力されなければ、Homeページ(root_url)へリダイレクトする。
    end
    
end
