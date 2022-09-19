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

COPY gcp/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080
