if [[ -d "${XDG_CONFIG_HOME}/zsh/custom" ]]; then
  # Source all .zsh files in the custom directory
  for config_file in "${XDG_CONFIG_HOME}/zsh/custom"/*.zsh; do
    if [[ -f "$config_file" ]]; then
      # echo "Sourcing $config_file..."
      source "$config_file"
    fi
  done
fi
