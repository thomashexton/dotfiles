function print_wattage
  while true
    set wattage ( /usr/sbin/system_profiler SPPowerDataType | grep -E 'Wattage \(W\): (.*)' 2>/dev/null | awk '{print $3}' )
    if test -z "$wattage"
      echo "no charger connected"
    else
      echo "current wattage: $wattage"W
    end
    sleep 1
  end
end
