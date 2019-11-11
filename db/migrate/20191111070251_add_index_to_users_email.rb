class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
  end
  # usersテーブルのemailカラムにindexを追加するという意味。indexを付与すると多数のデータからの検索効率を向上させられる。
  # index自体は一意性を強制しないので、オプションでunique: trueを指定することで実現
end
