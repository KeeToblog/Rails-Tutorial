source 'https://rubygems.org'

gem 'rails',        '5.1.6'
gem 'gravtastic'
# Gravatarでプロフィール写真をアップし、指定のメルアドと関連付けができる。
gem 'bcrypt',         '3.1.12'
# パスワードを適切にハッシュ化（データを不可逆化）してパスワードなどが漏洩してもログインできないようにする。
gem 'faker-okinawa'
# 沖縄っぽい言葉をつくるgem
gem 'faker',          '1.7.3'
# ダミーユーザーをつくるgem。普通は開発環境以外では使わない。
gem 'carrierwave',             '1.2.2'
# 投稿した画像を暑かったり、その画像をMicropostモデルと関連付ける
gem 'mini_magick',             '4.7.0'
# 画像をリサイズする
gem 'will_paginate',           '3.1.6'
# ページネーション（１ページに適当な数だけユーザーを表示する）機能を付与する
gem 'bootstrap-will_paginate', '1.0.0'
# Bootstrapのページネーションスタイルを使ってwill_pagenateを構成する。
gem 'bootstrap-sass', '3.3.7'
# カスタムCSSルールとBootstrapを組み合わせる。
# Bootstrapを使うことでアプリケーションをレスポンシブデザインにできる
gem 'puma',         '3.12.3'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri
end
# SQliteは開発環境でのみ使う。

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  # Guardはファイルシステムの変更を監視し、テストを自動的に実行してくれるツール
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.20.0'
  # 本番環境ではpg(PostgreSQLデータベースを使う)
  gem 'fog', '1.42'
  # 画像をアップロードする
end


# Windows環境ではtzinfo-dataというgemを含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]