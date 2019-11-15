# 記憶ダイジェスト用に生成したマイグレーション
# マイグレーション名を_to_usersにすることでマイグレーションの対象がDBのusersテーブルであることをRailsに指示できる。
# 記憶ダイジェストはユーザーが直接読めるようにしてはならないので、remember_digestカラムにインデックスを追加する必要はない
class AddRememberDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remember_digest, :string
  end
end
