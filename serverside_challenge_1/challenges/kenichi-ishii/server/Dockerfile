FROM ruby:3.1.3

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install bundler

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
RUN rails db:create
RUN rails db:migrate
RUN rails db:seed

CMD ["rails", "server", "-b", "0.0.0.0"]