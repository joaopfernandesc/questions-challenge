#! /bin/sh

# If the database exists, migrate. Otherwise setup (create and migrate)
RAILS_ENV=development bundle exec rake db:migrate 2>/dev/null || RAILS_ENV=development bundle exec rake aux:recreate_questions db:create db:migrate db:seed
echo "Done!"