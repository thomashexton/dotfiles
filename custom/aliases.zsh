# Homebrew
alias ibrew="arch -x86_64 /usr/local/bin/brew"
alias remove_postgres_pid="rm -f $HOMEBREW_PREFIX/var/postgres/postmaster.pid"

# Rails
alias be="bundle exec"
alias rs="bundle exec rails s"
alias rc="bundle exec rails c"
alias db:reset="bundle exec rake db:reset"
alias db:reset:test="bundle exec rake db:reset RAILS_ENV=test"
alias db:migrate="bundle exec rake db:reset"
alias db:migrate:test="bundle exec rake db:migrate RAILS_ENV=test"
alias db:rollback="bundle exec rake db:rollback"
alias db:rollback:test="bundle exec rake db:rollback RAILS_ENV=test"
alias rspec="bundle exec rspec"
alias wpds="./bin/webpack-dev-server"

# Git
alias gcfo="git config --list --show-origin"
alias gfd="git diff --name-status master.."

# Nicely formatted diff for announcements
alias deploydiff="git log main..staging --pretty=format:"%<(23)%an    %s" --abbrev-commit"

# iCloud dir
alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"

# Edit hosts file
alias hosts="sudo $VISUAL_EDITOR /etc/hosts"

# GC Start
alias e="$EDITOR"
alias ve="$VISUAL_EDITOR"

# Use nvim instead of vim/vi
alias vim="nvim"
alias vi="nvim"
alias yab="vim ~/.yabairc"
alias skh="vim ~/.skhdrc"

# This is required so you can use aliases with "watch"
alias watch="watch "

# Show the weather
alias wx="curl v2.wttr.in"

# Copy public ip to the clipboard
alias pubip="curl -s ipv4.icanhazip.com | tee >(pbcopy)"

# Copy my public SSH rsa to clipboard
alias pubssh="pbcopy < ~/.ssh/id_rsa.pub"
