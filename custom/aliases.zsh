# Kubernetes
alias be="bundle exec"
alias rick="bundle exec rails s webrick"
alias rs="bundle exec rails s"
alias rc="bundle exec rails c"
alias spst="spring stop"
alias dbmigrate="bundle exec rake db:migrate"
alias dbrollback="bundle exec rake db:rollback"
alias db:reset="bundle exec rake db:reset"
alias db:reset:test="bundle exec rake db:reset RAILS_ENV=test"
alias rspec="bundle exec rspec"
alias kill-everything="pkill -9 -f 'rb-fsevent|rails|spring|puma'"
alias gqlschema="bundle exec rake graphql:dump_schema"

# Git
alias gcpr="git checkout production"
alias gfd="git diff --name-status master.."
# Nicely formatted diff for announcements
alias deploydiff="git log production..master --pretty=format:'%<(23)%an    %s' --abbrev-commit"

# Kubernetes
alias rollback-site="kubectl rollout undo deployment/site -n site"
alias rollback-graphql="kubectl rollout undo deployment/graphql -n site"
alias kstage='asdf shell kubectl 1.15.11 && asp staging && aws eks update-kubeconfig --name=staging-gitops-v1 --alias=staging && kubectx staging'
alias kprod='asdf shell kubectl 1.8.6 && asp production && kubectx production'

# Boot Sidekiq locally
alias bsq="bundle exec sidekiq -C config/containers/sidekiq/sidekiq.yml"

# iCloud dir
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

# Postgres
alias pg_start="launchctl load ~/Library/LaunchAgents"
alias pg_stop="launchctl unload ~/Library/LaunchAgents"

# Edit hosts file
alias hosts='sudo $VISUAL_EDITOR /etc/hosts'

# GC Start
alias cl='clear'
alias e='$EDITOR'
alias ve='$VISUAL_EDITOR'

# Use nvim instead of vim/vi
alias vim='nvim'
alias vi='nvim'

# This is required so you can use aliases with 'watch'
alias watch='watch '

# Show the weather
alias wx='curl v2.wttr.in'

# Copy public ip to the clipboard
alias pubip='curl -s ipv4.icanhazip.com | tee >(pbcopy)'
