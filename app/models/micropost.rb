class Micropost < ApplicationRecord
  belongs_to :user
  # 「１対多」の「多」側にbelongs_toを書く。
  default_scope -> { order(created_at: :desc) }
  # 上はラムダ式(Stabby lambda)という文法。Procやlambda(もしくは無名関数)と呼ばれるオブジェクトを作成する。
  # {}←ブロックを引数に取り、Procオブジェクトを返す。callメソッドが呼ばれた時、ブロック内の処理を評価する。
  mount_uploader :picture, PictureUploader
  # CarrierWaveに画像と関連付けたモデルを伝えるには、mount_uploaderメソッドを使う。
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
      # 5MBを越えたらエラーメッセージが表示される
    end
end
