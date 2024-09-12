function print_wattage {
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

function reset_tracked_branches {
    # Set the remote branches to track
    git remote set-branches origin master green 'thomashexton-*' 'jayt-*' 'bnguyen*' 'fahad*'

    # Fetch the updated branch references from the remote
    git fetch --prune

    # The --prune option above will delete any stale tracking branches
    # that are no longer present on the remote. If you also want to delete
    # local branches that are no longer tracking a remote branch, you can use:
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

function get_yabai_window_app_name {
  sleep "$1" && yabai -m query --windows --window
}

# Yabai Service Handler
function yabai_service {
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
function yab {
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
