FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim graphviz
RUN useradd -ms /bin/bash rails
RUN mkdir /app
# Gemfile をコピー（権限を rails に変更）
COPY --chown=rails:rails Gemfile Gemfile.lock /app/
USER rails
WORKDIR /app
RUN bundle install
# アプリ本体をコピー（rails ユーザーに所有権）
COPY --chown=rails:rails . /app