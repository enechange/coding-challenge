#!/bin/sh
set -e

echo "本番環境をを起動します"

bundle exec rails s -p ${PORT:-8080} -b "0.0.0.0"
