# iCloud dir
alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"

alias e="${EDITOR}"
alias ve="${VISUAL_EDITOR}"

# Use nvim instead of vim/vi
alias vim="nvim"
alias vi="nvim"

# Quick open files
alias hosts="sudo ${VISUAL_EDITOR} /etc/hosts"
alias skhc="nvim ~/.skhdrc"

# Show the weather
alias wx="curl v2.wttr.in"

# Copy public ip to the clipboard
alias pubip="curl -s ipv4.icanhazip.com | tee >(pbcopy)"

# Copy my public SSH rsa to clipboard
alias pubssh="pbcopy < ~/.ssh/personal_laptop_ed25519.pub"
