 #!/usr/bin/env python

import time
import serial
import sys, os

try:
  ser_send = serial.Serial(
    port='/dev/ttyAMA0', baudrate = 1200, timeout=1,
    parity=serial.PARITY_EVEN,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.SEVENBITS
  )

  ser_recv = serial.Serial(
    port='/dev/ttyUSB0', baudrate = 1200, timeout=1,
    parity=serial.PARITY_EVEN,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.SEVENBITS
  )

  counter=0

  # Try send receive 10 times 
  while counter<20:
    sys.stdout.write('Sending Teleinfo %d ... '%(counter))
    sys.stdout.flush()
    # Send data
    ser_send.write('Teleinfo %d\n'%(counter))
    time.sleep(1)
    # Try to read Data back
    s=ser_recv.readline()
    # Data correct ?
    if s.find("Teleinfo") != -1:
      print "Transmission OK"
      ser_recv.close()
      ser_send.close()
      os._exit(0)
    else:
      print "Nothing Received!"
      print s
      
    counter += 1

  # Clean exit even if error
  ser_recv.close()
  ser_send.close()
  os._exit(1)
    
except:
  os._exit(1)
   
