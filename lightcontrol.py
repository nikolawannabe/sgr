import serial
import time
import sys

blinkTime = 1
numBlinks = int(sys.argv[1])
s = serial.Serial("/dev/tty.usbmodem12341")
colorTime = 10

def shiftColor(color):
    s.write('H')
    s.write(color)
    time.sleep(colorTime)
    s.write('L')

def blinkenLights(num):
    for x in range(num):
        s.write('H')
        time.sleep(blinkTime)
        s.write('L')
        time.sleep(blinkTime)
    

shiftColor('R')
time.sleep(1)
shiftColor('G')
time.sleep(1)
shiftColor('B')
time.sleep(1)

s.close()
