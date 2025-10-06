# ベースイメージ
FROM ruby:3.1.2

# 必要パッケージ
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  vim \
  && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ
WORKDIR /app

# Gemfile を先にコピーして bundle install（キャッシュ活用）
COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 3

# アプリ全体コピー
COPY . .

# PID ファイル削除してサーバー起動
#CMD ["sh", "-c", "rm -f tmp/pids/server.pid && RAILS_ENV=production bin/rails server -b 0.0.0.0 -p 8080"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]


#FROM ruby:3.1.2
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim postgresql-client
#RUN mkdir /app
#WORKDIR /app
#ADD Gemfile /app/Gemfile
#ADD Gemfile.lock /app/Gemfile.lock
#RUN bundle install
#ADD . /app
## Gemfile
#COPY Gemfile* ./
#RUN bundle install
## アプリコードコピー
#COPY . .
## デフォルトコマンド（Fly.io が起動時に使用）
#CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]


#FROM ruby:3.1.2
#RUN apt-get update -qq && apt-get install -y \
#  build-essential \
#  libpq-dev \
#  nodejs \
#  yarn \
#  vim
#
## 作業ディレクトリ
#WORKDIR /app
## bundler を最新化（bundle not found 防止）
#RUN gem install bundler
## Gemfile を先にコピーして bundle install
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
## アプリ全体をコピー
#COPY . .
## ポートを公開
#EXPOSE 3000
#ENV RAILS_ENV=production
#ENV RACK_ENV=production
## Rails サーバーを起動
#CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]