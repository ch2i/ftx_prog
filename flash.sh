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


printOK() {
  echo ""
  echo ">>>>>>>>>>>>>>>>>>> OK <<<<<<<<<<<<<<<<<<<<"
  echo ""
}

printERROR() {
  echo ""
  echo "******************* ERROR ******************"
  echo ""
}

# Script Start 
echo "Micro Teleinfo Programming Script"
read -p "Please enter starting Serial Number (1000 to 9000) >" SERNUM

echo "Serial is $SERNUM"
if [[ $SERNUM -lt 1000 || $SERNUM -gt 9000 ]]; then
  echo "Serial number should be between 1000 and 9000"
  exit 1
else
  echo "Serial number is ok"
fi

while true; do
  #default not OK
  OK=1
  
  echo "-------------------------------------------"
  echo "Searching for USB Dongle with FT230-X CHIP "
  echo "will be flashed with serial TELEINFO-$SERNUM"
  echo "-------------------------------------------"
  waitDevice

  # Program USB Dongle with default values
  echo "-------------------------------------------"
  echo "Programming USB Dongle with defaults values"
  echo "-------------------------------------------"
  safeRunCommand "./ftx_prog --new-serial-number TINFO-0000 --cbus 2 PWREN --cbus 1 TxLED --invert rxd"
  #safeRunCommand "./ftx_prog --restore teleinfo.bin"
  retval=$?
  # reset USB dongle, LED should be RED
  usb_modeswitch -v 0x0403 -p 0x6015 --reset-usb --quiet
  waitDevice
  if [ "$retval" == 0 ] ; then
    printOK
    echo "-------------------------------------------"
    echo "      Checking Send and Receive data       "
    echo "-------------------------------------------"
    safeRunCommand "python ./serial_check.py"
    retval=$?
    if [ "$retval" == 0 ] ; then
      printOK
      echo "-------------------------------------------"
      echo "Flashing module with serial number $SERNUM"
      echo "-------------------------------------------"
      safeRunCommand "./ftx_prog --new-serial-number TINFO-$SERNUM --cbus 1 PWREN --cbus 2 TxLED --noinvert rxd"
      retval=$?
      # reset USB dongle, LED should be GREEN
      usb_modeswitch -v 0x0403 -p 0x6015 --reset-usb --quiet
      waitDevice
      if [ "$retval" == 0 ] ; then
        printOK
        OK=0
      fi
    fi
  fi
  
  if [[ $OK -ne 0 ]]; then
    printERROR
  else
    echo "-------------------------------------------"
    echo "Flash Successfull, TINFO-$SERNUM can be packed"
    echo "-------------------------------------------"
    # Increment serial number
    SERNUM=$((SERNUM+1))
  fi

  echo "Unplug Micro Teleinfo Module from USB and"
  echo "insert a new fresh one to be flashed, the"
  echo "next one will have serial TINFO-$SERNUM"
  # Empty keyboard
  while read -r -t 0; do
    read -n 256 -r -s
  done
  
  read -p "press Enter to continue or q to quit " rep
  if [[ $rep == "Q" || $rep == "q" ]]; then
    echo ""
    echo "Exiting, remember to set Serial number to $SERNUM next time"
    echo ""
    break
  fi
 
done
 
