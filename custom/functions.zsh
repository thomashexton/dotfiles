#
# Usage:
# $> cnra myapp 7.0.0 --minimal --database=postgresql
#
function cnra() {
  # validate input
  if [ $# -lt 2 ]; then
    echo "Usage: cnra <project_name> <rails_version>"
    return 1
  fi

  # create dir, dive into dir, require desired Rails version
  mkdir -p -- "$1" && cd -P -- "$1"
  echo "source 'https://rubygems.org'" > Gemfile
  echo "gem 'rails', '$2'" >> Gemfile

  # install rails, create new rails app
  bundle install
  bundle exec rails new . --force ${@:3:99}
  bundle update

  # Create a default controller
  echo "class HomeController < ApplicationController" > app/controllers/home_controller.rb
  echo "end" >> app/controllers/home_controller.rb

  # Create a default route
  echo "Rails.application.routes.draw do" > config/routes.rb
  echo '  get "home/index"' >> config/routes.rb
  echo '  root to: "home#index"' >> config/routes.rb
  echo 'end' >> config/routes.rb

  # Create a default view
  mkdir app/views/home
  echo '<h1>This is h1 title</h1>' > app/views/home/index.html.erb

  # Create database and schema.rb
  bin/rails db:create
  bin/rails db:migrate
}

# https://www.bootrails.com/blog/how-to-create-tons-rails-applications/
function cnra7mp() {
  cnra myapp 7.0.0 --minimal --database=postgresql --skip-test
}
