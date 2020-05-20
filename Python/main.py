import time
time.sleep(1)
import machine as m
import os
try:
   os.mount(m.SDCard(slot=1,mosi=15,miso=2,sck=14,cs=13),"/sd")
except:
   os.mount(m.SDCard(slot=2,mosi=15,miso=2,sck=14,cs=13),"/sd")   
print(os.listdir("/sd"))
os.chdir("/sd")
from main_sd import *
