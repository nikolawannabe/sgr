from decimal import *
import serial
import time
import sys
import  pywapi
import string

blinkTime = 1
print sys.argv.count
if len(sys.argv) > 1:
    callInterval = int(sys.argv[1])
else:
    callInterval = 10

if len(sys.argv) > 2:
    numBlinks = int(sys.argv[2])
else:
    numBlinks = 20
if len(sys.argv) > 3:
    weatherStation = sys.argv[3]
else:
    weatherStation = 'KRNT'
s = serial.Serial("/dev/tty.usbmodem12341")
colorTime = 10
noaa_result = pywapi.get_weather_from_noaa('KJFK')

def shiftColor(color):
    s.write('H')
    s.write(color)
    #time.sleep(colorTime)
    #s.write('L')

def blinkenLights(num):
    for x in range(num):
        s.write('H')
        time.sleep(blinkTime)
        s.write('L')
        time.sleep(blinkTime)

def temperatureCallCycle():
    lastTemp = 10
    while 1:
      noaa_result = pywapi.get_weather_from_noaa(weatherStation)
      temp = Decimal(noaa_result['temp_f'])
      if lastTemp != temp:
        if (temp < 40):
            print temp 
            print ' B\n'
            shiftColor('B')
        elif (temp < 70):
            print temp
            print ' G\n'
            shiftColor('G')
        else:
            print temp
            print ' R\n'
            shiftColor('R')
      lastTemp = temp
      time.sleep(callInterval)

def ExerciseLEDTests():
    shiftColor('R')
    time.sleep(1)
    shiftColor('G')
    time.sleep(1)
    shiftColor('B')
    time.sleep(1)
    
    blinkenLights(numBlinks)

temperatureCallCycle()
s.close()
