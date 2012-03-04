from decimal import *
import serial
import time
from datetime import datetime
import sys
import  pywapi
import string

blinkTime = 1
if len(sys.argv) > 1:
    callInterval = int(sys.argv[1])
else:
    callInterval = 30*60

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

def motorGo():
    s.write('M')
    time.sleep(blinkTime)
    s.write('O')
    time.sleep(blinkTime)

def SmileFrown():
    s.write('S')
    time.sleep(blinkTime)
    s.write('F')
    time.sleep(blinkTime)

def NoExpression():
    s.write('N')

def GetWeatherCondition(prevCondition):
    weatherData = pywapi.get_weather_from_yahoo(98052,'')
    weatherCode = int(weatherData['condition']['code'])
    if weatherCode in [0,1,2,3,4,5,6,7,8,10,13,14,15,16,18,22,25,36,41,42,43,45,46]:
        s.write('A')
        print "Severe weather condition detected: "
        print weatherData['condition']['text']
    else:
        if prevCondition != weatherCode:
          s.write('C')
          print "Weather: " + weatherData['condition']['text']
    return weatherCode

def temperatureCallCycle():
    lastTemp = 10
    weatherCode = 0
    while 1:
      try:
        weatherCode = GetWeatherCondition(weatherCode)
        noaa_result = pywapi.get_weather_from_noaa(weatherStation)
        temp = Decimal(noaa_result['temp_f'])
        if lastTemp != temp:
          print datetime.now().ctime(), 
          if (temp <= 32):
              print temp
              print ' Freezing! Sent D.'
              shiftColor('D')
          elif  (temp < 40):
              print temp 
              print ' B\n'
              shiftColor('B')
          elif (temp < 45):
              print temp
              print ' G\n'
              shiftColor('G')
          else:
              print temp
              print ' R\n'
              shiftColor('R')
        lastTemp = temp
        time.sleep(callInterval)
      except (KeyboardInterrupt, SystemExit):
        print 'Quitting...'
        sys.exit()
      except:
        print "Unable to connect to the weather station."

def ExerciseLEDTests():
    shiftColor('R')
    time.sleep(6)
    shiftColor('G')
    time.sleep(6)
    shiftColor('B')
    time.sleep(6)

def ExerciseAllTests():
    for x in range(3):
      SmileFrown()
    s.write('S')
    for x in range(3):
        motorGo()
    ExerciseLEDTests()
    NoExpression()
    temperatureCallCycle()

temperatureCallCycle()
s.close()
