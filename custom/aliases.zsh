# Rails
alias be="bundle exec"
alias rs="be rails s"
alias rc="be rails c"
alias db:reset="be rake db:reset"
alias db:reset:test="be rake db:reset RAILS_ENV=test"
alias db:migrate="be rake db:migrate"
alias db:migrate:test="be rake db:migrate RAILS_ENV=test"
alias db:rollback="be rake db:rollback"
alias db:rollback:test="be rake db:rollback RAILS_ENV=test"
alias rspec="be rspec"

# iCloud dir
alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"

alias e="${EDITOR}"
alias ve="${VISUAL_EDITOR}"

# Use nvim instead of vim/vi
alias vim="nvim"
alias vi="nvim"

# Quick open files
alias hosts="sudo ${VISUAL_EDITOR} /etc/hosts"
alias yab="nvim ~/.yabairc"
alias skh="nvim ~/.skhdrc"

# Show the weather
alias wx="curl v2.wttr.in"

# Copy public ip to the clipboard
alias pubip="curl -s ipv4.icanhazip.com | tee >(pbcopy)"

# Copy my public SSH rsa to clipboard
alias pubssh="pbcopy < ~/.ssh/personal_laptop_ed25519.pub"

alias ipad-top="displayplacer 'id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 scaling:on origin:(0,0) degree:0' 'id:C909CF66-BE7B-40E2-9C1C-094AEB8E0DA6 res:1133x744 hz:60 color_depth:4 scaling:on origin:(297,-744) degree:0'"

alias ipad-bottom="displayplacer 'id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 scaling:on origin:(0,0) degree:0' 'id:C909CF66-BE7B-40E2-9C1C-094AEB8E0DA6 res:1133x744 hz:60 color_depth:4 scaling:on origin:(297,1117) degree:0'"

alias ipad-left="displayplacer 'id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 scaling:on origin:(0,0) degree:0' 'id:C909CF66-BE7B-40E2-9C1C-094AEB8E0DA6 res:1133x744 hz:60 color_depth:4 scaling:on origin:(-1133,373) degree:0'"
