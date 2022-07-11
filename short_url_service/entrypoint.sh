#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid 

rake db:create
rake db:migrate
rake db:seed

bundle exec whenever --update-crontab
rake 'firebase:certificates:force_request'

crond &

exec "$@"