class AccountActivationsController < ApplicationController
  
  # アカウントを有効化するeditアクション
  def edit
    user = User.find_by(email: params[:email])
    # paramsハッシュで受け取った（入力された）email値をemail属性に渡して、DBから同じemail値を持つユーザーを取り出し、userに代入する
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
    # 入力されたemail値がDBに存在して、かつDBの有効化済みのユーザーと一致。さらにはid値をactivation属性に渡してハッシュ化し、DBのactivation_digestと一致する。
    # !user.activated?はすでに有効になっているユーザーを誤って再度有効化しないために導入。
      user.activate
      # アカウントを有効にする（モデルに移動してリファクタリングした）
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
end
