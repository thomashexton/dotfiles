function reset_tracked_branches {
    git remote set-branches origin master green 'thomashexton-*' 'jayt-*' 'regina*' &&
    git fetch --prune &&
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs --no-run-if-empty git branch -D
}
