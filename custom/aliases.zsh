alias cl='clear'
alias e='$EDITOR'
alias ve='$VISUAL_EDITOR'

# This is required so you can use aliases with 'watch'
alias watch='watch '

# Nicely formatted diff for announcements
alias deploydiff="git log production..master --pretty=format:'%<(23)%an    %s' --abbrev-commit"

# Edit hosts file
alias hosts='sudo $EDITOR /etc/hosts'

# Use neovim instead of vim, it's just friendlier
alias vim='nvim'

# Git
alias gcpr="git checkout production"

# Kubernetes
alias rollback-site="kubectl rollout undo deployment/site -n site"
alias rollback-graphql="kubectl rollout undo deployment/graphql -n site"
alias kstage='asdf shell kubectl 1.15.11 && asp staging && aws eks update-kubeconfig --name=eks-staging-v1 --alias=staging && kubectx staging'
alias kprod='asdf shell kubectl 1.8.6 && asp production && kubectx production'

# Rails
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

# Finder Shortcuts
alias cdsite="cd ~/Oneflare/Site"
alias site="cd ~/Oneflare/Site"
alias cdelmo="cd ~/Oneflare/elmo"
alias elmo="cd ~/Oneflare/elmo"
alias cdwomo="cd ~/Oneflare/womo"
alias womo="cd ~/Oneflare/womo"

alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

# Displayplacer Setups
# # Switch Res to 1080p
alias hd1080='displayplacer "id:120F7F58-74F0-A671-FAC3-4A43FC492AC8 res:1920x1080 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:8F203084-8EC4-5D28-9618-86A96CAA2871 res:1080x1920 hz:120 color_depth:8 scaling:off origin:(1920,-420) degree:270"'

# # Switch Res to 1440p
alias hd1440='displayplacer "id:120F7F58-74F0-A671-FAC3-4A43FC492AC8 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:8F203084-8EC4-5D28-9618-86A96CAA2871 res:1080x1920 hz:120 color_depth:8 scaling:off origin:(1920,-240) degree:270"'
