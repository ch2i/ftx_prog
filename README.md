This repo is to be used from Linux command-line to program [micro teleinfo](http://hallard.me/category/tinfo/) modules.
These module need to be programmed before the first use. 

It will flash the FTDI module EEPROM with correct configuration and serial Number then check Serial communication receveid my Micro Teleinfo Module.

## Test Theory

- Plug USB Module 
- Flash default FTDI FT230X config to check communication between USB Computer (Raspberry PI) and Micro Teleinfo Module
- Check RED Led 
- Check Serial Communication comming from Module Teleinfo input simulating sending data using Raspberry PI Serial Port
- Flash final FTDI FT230X config (LED and device Serial Number) 
- Check Serial Number and GREEN Led 

## Test Tools

- Rapsberry PI (2 or 3) installed with latest [Raspbian Jessie Lite](https://www.raspberrypi.org/downloads/raspbian/)
- 2 x Dupond cable or build cable from dupond and Pogo Pins depending the best use you choose for testing
- Test Software installed (this repo)
- Some USB Micro Teleinfo to flash

## Installation

Download and install the latest [Raspbian Jessie Lite](https://www.raspberrypi.org/downloads/raspbian/) image.
Look at the procedure [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

Once installed plug you can work directly on the Raspberry PI connected with a monitor, keyboard and mouse but my favorite is to connect to Raspberry PI with ssh (PI need to be connected on you network either with RJ45 cable or WiFi) and work from my main computer.

To connect your PI to WiFi from command line, here is the [procedure](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md) then you can log off and ssh to it with 
```
ssh raspberrypi.local
```

So from now, assuming you are logged on the PI (locally or with ssh) 

Use [raspi-config](https://www.raspberrypi.org/documentation/configuration/raspi-config.md) to change serial settings with 
Advanced Options / Serial / and set No to "Would you like a login shell to be accessible over serial?""
You can also change your PI hostname.

If you have a Raspberry PI Version 3, Serial has changed. Check see this [post](https://hallard.me/enable-serial-port-on-raspberry-pi/) but we need to have reliable Serial on `/dev/ttyAMA0` as before, so we will use the hardware one using overlays to remap as follow
Edit the file `/boot/config.txt` and add the following two lines at the end :

```
dtoverlay=pi3-miniuart-bt
enable_uart=1
```

Then stop bluetooth service and reboot with 

```
sudo systemctl disable hciuart
sudo reboot
```

Update your PI

```
sudo apt-get update
sudo apt-get upgrade
```

Install some prerequisites tools

```
sudo apt-get install build-essential gcc make libftdi-dev git-core python-serial
```

Then install and build the test tools

```
git clone https://github.com/ch2i/ftx_prog
cd ftx_prog
make
chmod ug+x flash.sh serial_check.py
```

## Hardware 

Connect Raspberry PI P1 connector pin 6 (ground) and pin 8 (TXD) to Micro Teleinfo input connector (whatever wire order, no matter)

![schematic](https://raw.github.com/ch2i/master/ftx_prog/pictures/micro_teleinfo_pi.jpg)


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

