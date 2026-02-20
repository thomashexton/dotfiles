export PATH="$HOME/.local/bin:$PATH"

export ZSHZ_DATA="${XDG_CACHE_HOME}/.z"

export EDITOR='zed --wait'
export VISUAL_EDITOR='zed --wait'

# Auto-attach or create a tmux session when opening a terminal
if [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi
