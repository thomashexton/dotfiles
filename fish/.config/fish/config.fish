eval (/opt/homebrew/bin/brew shellenv)

fish_add_path ~/.config/bin

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

set -Ux EDITOR nvim # neovim
set -Ux VISUAL_EDITOR zed # visual studio code

set -U fish_greeting # disable fish greeting
set -U fish_key_bindings fish_vi_key_bindings

abbr bi "brew install"
abbr bic "brew install --cask"
abbr binf "brew info"
abbr binfc "brew info --cask"
abbr bs "brew search"

# Yabai & SKHD
abbr yab "nvim ~/.yabairc"
abbr skh "nvim ~/.skhdrc"
abbr yabsto "yabai --stop-service"
abbr yabsta "yabai --start-service"

starship init fish | source
