#!/bin/bash

rm -f /myapp/tmp/pids/server.pid

rails db:create
rails db:migrate
rails db:seed

exec "$@"