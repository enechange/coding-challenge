# README

## API

- [openapi.yml](https://github.com/takaheraw/coding-challenge/tree/feature/serverside_challenge_2_simulate_api/serverside_challenge_2/challenge/doc/openapi/openapi3_0.yaml)
- [swagger-ui](https://github.com/takaheraw/coding-challenge/tree/feature/serverside_challenge_2_simulate_api/serverside_challenge_2/challenge/doc/openapi/dist/index.html)

![swagger-ui](https://i.gyazo.com/7d38c39800f38a4dd45fdd170293ab01.png)

## Setup

- development

```sh
bundle install
bundle exec rails db:setup
bundle exec rails s -b 0.0.0.0
```

- test

```sh
RAILS_ENV=test bundle exec rails db:setup
RAILS_ENV=test bundle exec rspec spec/
```
