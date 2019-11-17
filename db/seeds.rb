# Example Userという名前のユーザーをつくる（seedsを実行したときにこのユーザーでログインして一覧ページを見るため？）
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
# create!はユーザーが無効な場合にfalseを返すのではなく、例外を発生させる。

# 99人のダミーユーザーをつくる
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end