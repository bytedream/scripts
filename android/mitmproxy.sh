#!/usr/bin/env sh

res=

choose_emulator() {
  emulators=($(emulator -list-avds | tr ' ' '\n'))

  if [ ${#emulators[@]} -eq 0 ]; then
    echo "No avds found. Please create (at least) one"
    exit 1
  fi

  echo "Choose one of the following ${#emulators[@]} avds:"
  i=0
  for emulator in ${emulators[@]}; do
    i=$((i+1))
    echo "  $i) $emulator"
  done
  printf "AVD (number): "
  read avd
  avd_index=$((avd-1))

  if [ ! -v 'emulators[avd_index]' ]; then
    echo "'$avd' is not a valid number"
    exit 1
  fi

  res=${emulators[$avd_index]}
}

ca_certname() {
  certname=$(openssl x509 -inform PEM -subject_hash_old -in ~/.mitmproxy/mitmproxy-ca-cert.cer | head -1)
  res=$certname.0
}

ensure_ca_cert() {
  ca_certname
  certname=$res
  cp ~/.mitmproxy/mitmproxy-ca-cert.cer ~/.mitmproxy/$certname
}

proxy_address() {
  proxy=$(ip route get 1.1.1.1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'):8080
  if [[ -v MITMPROXY_ADDRESS ]]; then
    proxy=$MITMPROXY_ADDRESS
    echo "Using proxy address set via 'MITMPROXY_ADDRESS' env variable ($proxy)"
  else
    echo "Using default proxy settings ($proxy). Set the 'MITMPROXY_ADDRESS' env variable to overwrite the proxy address. Always use your network address instead of 127.0.0.1"
  fi
  res=$proxy
}

verify_commands() {
  commands=("adb" "emulator" "mitmproxy")
  for command in "${commands[@]}"; do
    which $command &> /dev/null
    if [ $? -ne 0 ]; then
      # if the command cannot be found it maybe wasn't added to PATH but still exists on the system
      case $command in
        adb)
          PATH=$PATH:$HOME/Android/Sdk/platform-tools
          ;;
        emulator)
          PATH=$PATH:$HOME/Android/Sdk/emulator
          ;;
      esac
      which $command &> /dev/null
      if [ $? -ne 0 ]; then
        echo "command '$command' not found"
        exit 1
      fi
      echo "Warn: command '$command' was found ($(which $command)) but isn't in PATH"
    fi
  done
}

verify_certs() {
  if [ ! -f ~/.mitmproxy/mitmproxy-ca-cert.cer ]; then
    echo "mitmproxy ca cert doesn't exist (~/.mitmproxy/mitmproxy-ca-cert.cer). Please run mitmproxy at least once to generate it"
    exit 1
  fi
}

up() {
  verify_certs
  choose_emulator
  avd=$res

  # shut down existing avds
  down &> /dev/null

  adb kill-server &> /dev/null
  adb start-server > /dev/null
  emulator -avd $avd -writable-system > /dev/null &
  adb wait-for-device

  if [ "$(adb shell getprop ro.build.fingerprint)" = "*/release-keys" ]; then
    echo "Doesn't work on release android version. Please use an emulator without Google Play."
    exit 1
  fi

  ensure_ca_cert
  ca_certname
  ca_cert=$res

  adb root
  # without sleeping adb wouldn't find the emulator
  sleep 5

  api_version=$(adb shell getprop ro.build.version.sdk)
  if [[ "$api_version" -gt "28" ]]; then
    adb shell avbctl disable-verification
    adb reboot
    adb wait-for-device
    adb root
    sleep 5
  fi

  adb remount

  adb push ~/.mitmproxy/$ca_cert /system/etc/security/cacerts
  adb shell chmod 644 /system/etc/security/cacerts/$ca_cert

  adb reboot
  # wait until device has actually booted. this is required b/c it needs to be booted in order to set the proxy
  while [ "`adb shell getprop sys.boot_completed 2> /dev/null | tr -d '\r' `" != "1" ]; do sleep 1; done

  proxy_address
  proxy_addr=$res
  adb shell settings put global http_proxy $proxy_addr
}

down() {
  adb shell settings delete global http_proxy
  adb shell reboot -p
}

main() {
  case "$1" in
    up)
      verify_commands
      up
      ;;
    down)
      verify_commands
      down
      ;;
    *)
      echo "$0 [up|down]"
      exit 1
      ;;
  esac
}

main $@

