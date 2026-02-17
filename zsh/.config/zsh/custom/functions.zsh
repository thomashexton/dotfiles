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
    git remote set-branches origin master green 'thomashexton-*' 'jayt-*' 'regina*'

    # Fetch the updated branch references from the remote
    git fetch --prune

    # The --prune option above will delete any stale tracking branches
    # that are no longer present on the remote. If you also want to delete
    # local branches that are no longer tracking a remote branch, you can use:
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}
