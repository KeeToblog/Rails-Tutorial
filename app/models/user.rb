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
end
# before_saveのselfは現在のユーザーを指す。
# VLID_EMAIL_REGEXは正規表現の定数。意味不明に見えるが意味はある。
# Rubularに突っ込めばテストができる。