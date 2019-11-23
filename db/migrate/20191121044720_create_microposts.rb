class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    # 一つの配列に２つの属性を含めることで、両方のキーを同時に扱う複合キーインデックスを作成する
  end
end
