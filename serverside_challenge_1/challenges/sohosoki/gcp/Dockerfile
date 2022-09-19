FROM ruby:3.1
ARG RUBYGEMS_VERSION=3.3.20

RUN mkdir /var/app
WORKDIR /var/app
COPY Gemfile /var/app/Gemfile
COPY Gemfile.lock /var/app/Gemfile.lock
RUN gem update --system ${RUBYGEMS_VERSION}
RUN bundle install
COPY . /var/app

ENV RAILS_ENV=production

EXPOSE 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]