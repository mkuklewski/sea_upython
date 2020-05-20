#
# Loader of FPGA bitstream for SEA (Spartan_Edge_Accelerator).
# Written by Wojciech M. Zabolotny (wzab01@gmail.com)
# and publish as PUBLIC DOMAIN
# Based on code published in
# https://github.com/shantzis62/sea-fpga-loader
#
import time
import struct
t_start=time.time()
f=open("/sd/main.bit","rb")
tmp=f.read(2)
# Field 1
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
# Field 2
tmp=f.read(2)
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
assert(tmp==b'a')
print(tmp)
# Field 3 - design
tmp=f.read(2)
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
print('Design: '+tmp.decode())
# Field 4
tmp=f.read(1)
print(tmp)
assert(tmp==b'b')
tmp=f.read(2)
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
print('Part: '+tmp.decode())
# Field 4b - Date
tmp=f.read(1)
print(tmp)
assert(tmp==b'c')
tmp=f.read(2)
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
print('Date: '+tmp.decode())
# Field 5 - Time
tmp=f.read(1)
print(tmp)
assert(tmp==b'd')
tmp=f.read(2)
bl=struct.unpack(">H",tmp)[0]
print(bl)
tmp=f.read(bl)
print('Time: '+tmp.decode())
# Field 6 - Data
tmp=f.read(1)
print(tmp)
assert(tmp==b'e')
tmp=f.read(4)
bl=struct.unpack(">L",tmp)[0]
print(bl)
# Now we can read configuration bytes in the loop and transmit it to the FPGA
import machine as m
# We use the SPI interface to speed-up programming
s=m.SPI(1,baudrate=2000000,firstbit=m.SPI.MSB,sck=m.Pin(17),mosi=m.Pin(27))
p_program_b = m.Pin(25,m.Pin.OUT)
p_int_b = m.Pin(26,m.Pin.IN)
p_done = m.Pin(26,m.Pin.IN)
# Initialize outputs
p_program_b.value(0)
s.write(b'0')
p_program_b.value(1)
print("FPGA start reset")
# Wait until FPGA finishes reset
while (p_int_b.value()==0):
   pass
print("FPGA end reset")
# Now program in the loop
while(bl>0):
   #print("remains: "+str(bl))
   blen=min(bl,10000)
   bf=f.read(blen)
   s.write(bf)
   bl -= blen
time.sleep_ms(10)
if p_done.value()==1:
   print("FPGA Configuration: Success")
else:
   print("FPGA Configuration: Failure")
t_end=time.time()
print("Configuration took: "+str(t_end-t_start)+" seconds.")

