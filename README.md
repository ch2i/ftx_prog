**ftx_prog** is a Linux command-line to program [micro teleinfo](http://hallard.me/category/tinfo/) modules.

It will flash the FTDI module EEProm with correct configuration then check Receive sending data to Raspberry PI Uart and check that data is receveid my Micro Teleinfo Module.

## Installation

Install some prerequisites

```
sudo apt-get install build-essential gcc make libftdi-dev git-core python-serial
```

then install and build

```
git clone https://github.com/ch2i/ftx_prog
cd ftx_prog
make
chmod ug+x flash.sh serial_check.py
```

## Hardware 

Connect Raspberry PI P1 connector pin 6 (ground) and pin 8 (TXD) to Micro Teleinfo input connector (whatever order, no matter)

## Usage

You just need to follow the procedure on te screen, enter 1st bach Serial Number at startup.

During flash and test RED led should be ON and after all is okay GREEN led should be ON

```
root@pi03(ro):~/ftx-prog# sudo ./flash.sh
Micro Teleinfo Programming Script
Please enter starting Serial Number (1000 to 9000) >1000
Serial is 1000
Serial number is ok
-------------------------------------------
Searching for USB Dongle with FT230-X CHIP
will be flashed with serial TELEINFO-1000
-------------------------------------------
Waiting USB device to be plugged...
Found at /sys/bus/usb/devices/1-1.4
-------------------------------------------
Programming USB Dongle with defaults values
-------------------------------------------
Micro Teleinfo flasher V1.0
teleinfo.eep: read 256 bytes
Serial = TINFO-0000
InvRXD = True
CBUS1  = TxLED
CBUS2  = PWREN
Rewriting eeprom with new contents.
Waiting USB device to be plugged...
Found at /sys/bus/usb/devices/1-1.4

>>>>>>>>>>>>>>>>>>> OK <<<<<<<<<<<<<<<<<<<<

-------------------------------------------
      Checking Send and Receive data
-------------------------------------------
Sending Teleinfo 0 ... Transmission OK

>>>>>>>>>>>>>>>>>>> OK <<<<<<<<<<<<<<<<<<<<

-------------------------------------------
Flashing module with serial number 1000
-------------------------------------------
Micro Teleinfo flasher V1.0
Serial = TINFO-1000
InvRXD = False
CBUS1  = PWREN
CBUS2  = TxLED
Rewriting eeprom with new contents.
Waiting USB device to be plugged...
Found at /sys/bus/usb/devices/1-1.4

>>>>>>>>>>>>>>>>>>> OK <<<<<<<<<<<<<<<<<<<<

-------------------------------------------
Flash Successfull, TINFO-1000 can be packed
-------------------------------------------
Unplug Micro Teleinfo Module from USB and
insert a new fresh one to be flashed, the
next one will have serial TINFO-1001
press Enter to continue or q to quit q

Exiting, remember to set Serial number to 1001 next time

root@pi03(ro):~/ftx-prog# 
```

## License

GPL v2

## Credits

Modified for the FT-X series by Richard Meadows 2012

Based upon [ft232r_prog](http://rtr.ca/ft232r/), Version 1.23, by [Mark Lord](http://rtr.ca/). Copyright 2010-2012.

