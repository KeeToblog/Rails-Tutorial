class User < ApplicationRecord
  before_save { email.downcase! }
  #before_save { self.email = email.downcase } 
  #保存する直前に文字列を小文字にする。例えば、Foo@ExAMPle.Comとfoo@example.comは同じ文字列だとDBに解釈して欲しいから。
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } #true表示をfalseに変える。
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
# before_saveのselfは現在のユーザーを指す。
# VLID_EMAIL_REGEXは正規表現の定数。意味不明に見えるが意味はある。
# Rubularに突っ込めばテストができる。
# has_secure_passwordメソッドでセキュアなパスワードを実装できる。
# 1. セキュアにハッシュ化したパスワードを、DB内のpassword_digest属性に保存できる。
# 2. ２つのペアの仮想的な属性(passwordとpassword_confirmation)が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される。
# 3. authenticateメソッドが使えるようになる。

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # コストパラメータをテスト中は最小にする。
    BCrypt::Password.create(string, cost: cost)
    # fixture用のパスワードを作成する。costパラメーターでは、ハッシュを算出するための計算コストを指定する。
  end


end