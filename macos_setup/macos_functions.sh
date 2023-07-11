function set_mac_name() {
  printf "Please enter the desired name for your Mac: "
  read mac_name

  if [[ -z "${mac_name}" ]]; then
    echo "No input provided. No changes were made."
    exit 0
  fi

  sanitized_mac_name=$(echo -n "${mac_name}" | tr -dc '[:alnum:][:space:]' | tr '[:upper:]' '[:lower:]' | tr '[:space:]' '-')
  sanitized_mac_netbios_name=$(echo -n "${mac_name}" | tr -dc '[:alnum:]' | tr '[:lower:]' '[:upper:]' | cut -c 1-15)

  echo "You are about to set the following names:"
  echo "ComputerName: ${mac_name}"
  echo "HostName: ${sanitized_mac_name}"
  echo "LocalHostName: ${sanitized_mac_name}"
  echo "PlistHostName: ${sanitized_mac_name}"
  echo "NetBIOSName: ${sanitized_mac_netbios_name}"

  echo "Do you want to proceed? (y/n): "
  read -n 1 confirmation

  if [[ "${confirmation}" =~ [Nn] ]]; then
    echo
    echo "Operation cancelled. No changes were made."
    exit 0
  fi

  if sudo scutil --set ComputerName "${mac_name}" &&
     sudo scutil --set HostName "${sanitized_mac_name}" &&
     sudo scutil --set LocalHostName "${sanitized_mac_name}" &&
     sudo defaults write /Library/Preferences/SystemConfiguration/preferences.plist PlistHostName -string "${sanitized_mac_name}"; then
     sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${sanitized_mac_netbios_name}" &&
     echo
     echo "Successfully set names."
  else
    echo "An error occurred. Some names might not have been updated."
    exit 1
  fi
}
