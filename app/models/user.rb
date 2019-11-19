class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  # attr_accessorメソッドで「仮想の」属性を作成する。データを取り出すメソッド(getter)と、データに代入するメソッド(setter)をそれぞれ定義してくれる。
  # 具体的にはこの行の実行により、インスタンス変数@remember_tokenにアクセスするためのメソッドが用意される。
  # 後述するemail, remember_tokenメソッドも「仮想の」ローカル変数ではないので、selfをつける。
  before_create :create_activation_digest
  # ユーザーが新規登録する前に、有効化ダイジェストを作成する
  before_save :downcase_email
  # メルアドをDBに保存する前に、全て小文字化させる。
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # VLID_EMAIL_REGEXは正規表現の定数。意味不明に見えるが意味はある。Rubularに突っ込めばテストができる。
  validates :email, presence: true, length: {maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } #true表示をfalseに変える。
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil:true
# has_secure_passwordメソッドでセキュアなパスワードを実装できる。
# 1. セキュアにハッシュ化したパスワードを、DB内のpassword_digest属性に保存できる。(BCryptをgemに追加することでハッシュ化が可能になる)
# 2. ２つのペアの仮想的な属性(passwordとpassword_confirmation)が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される。
# 3. authenticateメソッドが使えるようになる。
# allow_nil:trueでパスワード空欄に対応。has_secure_passwordはオブジェクト生成時に存在性を検証するようになっているので、新規登録時にパスワードが空なのは有効にならない。



  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # コストパラメータをテスト中は最小にする。
    BCrypt::Password.create(string, cost: cost)
    # fixture用のパスワードを作成する。costパラメーターでは、ハッシュを算出するための計算コストを指定する。
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  # 64種類の文字列からなる長さが22の文字列を作る。ランダムなトークンを作る。
  
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # 記憶トークンを作成。selfをつけることで「仮想の」属性を持つローカル変数ではなく、設定通りの属性としてはたらいてくれる。
    update_attribute(:remember_digest, User.digest(remember_token))
    # User.digestを記憶トークンに適用した結果で記憶ダイジェストを更新する。
    # update_attributeメソッドはバリデーションを素通りして、オブジェクトを更新できる。
  end
  # 有効な（ランダムな）トークンを作り、それに関連したダイジェストを作成（更新）する。
  
  
  # トークンがダイジェストと一致したらtrueを返す（authenticated?メソッドの抽象化）
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
#  def authenticated?(remember_token)
#    return false if remember_digest.nil?
    # 記憶ダイジェストが存在しない(nil)とき、falseを返し、メソッドを終了する(return)。
#    BCrypt::Password.new(remember_digest).is_password?(remember_token)
#  end
  # BCryptで記憶ダイジェストを暗号化（ハッシュ化）し、渡された記憶トークンと比較する（authenticated?メソッド）。一致したらtrueを返す。
  # remember_tokenは、authenticated?メソッドのローカル変数。is_password?の引数はそれを参照する。
  # remember_digestの属性はDBのカラムに対応しており、ActiveRecordniyotte簡単に取得・保存できる。
  
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  # 記憶ダイジェストをnilで更新する。
  
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # 下のupdate_attributeは２回呼び出され、各行でDBに問い合わせているので、上のように呼び出しを一回にする。
    # update_attribute(:activated,    true)
    #  update_atributeメソッドがtrueのときは、更新と保存を同時に行う
    # update_attribute(:activated_at, Time.zone.now)
    #  最新の時間に更新・保存する。有効化(activated)と同時にやらない。
    #  update_attributeで一つずつやることで検証（バリデーション）を回避できる。
  end
  # Userモデルではuserという変数はないので、user.updateattributeという記法を使っていない
  # 元のコントローラーでの定義↓
  #  user.update_attribute(:activated,    true)
  #  user.update_attribute(:activated_at, Time.zone.now)


      
  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  # UserMailerを使って入力されたメルアド宛にアカウント有効化のメッセージを送信
  
  private
  # ユーザーモデル内でしか使わない

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end
    # selfは現在のユーザーを指す。
    # 保存する直前に文字列を小文字にする。例えば、Foo@ExAMPle.Comとfoo@example.comは同じ文字列だとDBに解釈して欲しいから。


    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      # 64種類の文字列からなる長さが22の文字列を作るランダムなトークンを有効化トークン(activation_token)に代入する。
      self.activation_digest = User.digest(activation_token)
      # 有効化トークンをハッシュ化してダイジェストとしたものを有効化ダイジェスト(activation_digest)に代入する。
    end

end