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

print_wattage() {
  while true
  do
    local wattage=$(/usr/sbin/system_profiler SPPowerDataType | grep -E 'Wattage \(W\): (.*)' 2>/dev/null | awk '{print $3}')
    if [[ -z "${wattage}" ]]; then
      echo "no charger connected"
    else
      echo "current wattage: ${wattage}W"
    fi
    sleep 1
  done
}

get_yabai_window_app_name() {
  result=$(sleep $1 && yabai -m query --windows --window)
  app=$(echo "$result" | jq -r '.app')
  title=$(echo "$result" | jq -r '.title')
  echo "\"app\":\"$app\""
  echo "\"title\":\"$title\""
}

check_proto_import() {
  local search_directory="$1"

  # Check if a directory is provided
  if [ -z "$search_directory" ]; then
    echo "Usage: check_proto_import <search_directory>"
    return 1
  fi

  # Use find to locate all .proto files under the directory
  # Then use grep to check for the absence of the import line
  # Finally, print out the file names that don't have the import
  find "$search_directory" -name "*.proto" -type f -print0 | while IFS= read -r -d '' file; do
    if ! grep -q 'import "protogen/protogen.proto";' "$file"; then
      echo "Missing import in $file"
    fi
  done
}

function reset_tracked_branches() {
    # Set the remote branches to track
    git remote set-branches origin master green 'thomashexton-*' 'jayt-*'
    
    # Fetch the updated branch references from the remote
    git fetch --prune
    
    # The --prune option above will delete any stale tracking branches 
    # that are no longer present on the remote. If you also want to delete
    # local branches that are no longer tracking a remote branch, you can use:
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

# Yabai Service Handler
yabai_service() {
  case "$1" in
    start)
      yabai --start-service
      ;;
    stop)
      yabai --stop-service
      ;;
    restart)
      yabai --stop-service && yabai --start-service
      ;;
    *)
      echo "Usage: yabai_service {start|stop|restart}"
      ;;
  esac
}

# Yabai Service Handler Shorthand
yab() {
  if [[ -z "$1" ]]; then
    echo "Usage: yab {sta|sto|res}"
    return
  fi

  # Map shortened commands to full commands for yabai_service
  case "$1" in
    sta)
      yabai_service start
      ;;
    sto)
      yabai_service stop
      ;;
    res)
      yabai_service restart
      ;;
    *)
      echo "Unknown command: $1"
      echo "Usage: yab {sta|sto|res}"
      ;;
  esac
}
