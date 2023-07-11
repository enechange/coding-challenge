#!/bin/bash

rails db:create
rails db:migrate
rails db:seed

exec "$@"