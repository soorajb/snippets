#!/bin/sh
PATH=$PATH:/opt/ree
prod_dir='/srv/rails/myapp' 
# this dir needs to have something like :
# /srv/rails/myapp
# |-- current -> releases/20110915_144041/
# |-- deploy.sh
# |-- releases
# `-- shared

cd  $prod_dir

timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p releases/$timestamp
git clone /srv/git/myapp.git  "releases/$timestamp"
rm -rf releases/$timestamp/.git
rm -f current
ln -s releases/$timestamp/ current

cp shared/config/database.yml current/config/database.yml



mkdir current/tmp
mkdir current/log/
chmod a+w current/log/*
chmod a+w current/Gemfile.lock
ln -s "$prod_dir/shared/uploads" "$prod_dir/current/uploads"

cd current
/opt/ree/bin/bundle install
/opt/ree/bin/bundle exec rake db:migrate RAILS_ENV=production

touch current/tmp/restart.txt
