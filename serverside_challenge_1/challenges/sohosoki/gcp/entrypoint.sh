#!/bin/bash

rails db:migrate
rails db:seed

rm -f /var/app/tmp/pids/server.pid
rails server -b 0.0.0.0 -p 8080