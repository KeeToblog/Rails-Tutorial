# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  
  # アカウント有効化のプレビューメソッド
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    # userが開発用DBの最初のユーザーになるように定義し、UserMailer.account_activationの引数として渡す
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # パスワード再設定のプレビューメソッド
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end
