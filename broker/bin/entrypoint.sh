#!/usr/bin/env sh
set -e

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
bundle exec rake db:seed

exec bundle exec "$@"
