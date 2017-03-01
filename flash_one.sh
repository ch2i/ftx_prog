safeRunCommand() {
  cmnd="$@" 
  #$cmnd >/dev/null
  $cmnd 
  ERROR_CODE=$?
  if [ ${ERROR_CODE} != 0 ]; then
    printf "Error when executing command: '${command}'\n"
  fi
  return "${ERROR_CODE}"
}

waitDevice() {
  gotit=0
  echo "Waiting USB device to be plugged..."
  while [ $gotit -eq 0 ]; do
    # Scan USB device
    for DEV in /sys/bus/usb/devices/*; do
      if [[ "$(cat "$DEV/idVendor" 2>/dev/null)" == "0403" && "$(cat "$DEV/idProduct" 2>/dev/null)" == "6015" ]]; then
        gotit=1
        DEVICE=$DEV
      fi
    done
  done
  # Force device redetection
  echo "Found at $DEVICE"
  echo 0 >$DEVICE/authorized
  echo 1 >$DEVICE/authorized
}


# Script Start
echo "Micro Teleinfo Programming Script"
read -p "Please enter 4 digits Serial Number (0001 to 9999) >" SERNUM

echo "Serial is $SERNUM"
if [[ $SERNUM -lt 1 || $SERNUM -gt 9999 ]]; then
  echo "Serial number should be between 1 and 9999"
  exit 1
else
  echo "Serial number is ok"
fi

echo "-------------------------------------------"
echo "Searching for USB Dongle with FT230-X CHIP "
echo "will be flashed with serial TELEINFO-$SERNUM"
echo "-------------------------------------------"
waitDevice

# Program USB Dongle with default values
echo "-----------------------"
echo "Programming USB Dongle "
echo "-----------------------"
safeRunCommand "./ftx_prog --new-serial-number TINFO-$SERNUM --cbus 1 PWREN --cbus 2 TxLED"
 
# reset USB dongle, LED should be RED
usb_modeswitch -v 0x0403 -p 0x6015 --reset-usb --quiet

