#!/usr/bin/python3
# -*- coding: utf-8 -*-
import struct
import machine as m
class spibus_iface(object):
    def write(self,adr,value):
        cmd1=struct.pack(">LB",adr,0xc0)
        cmd2=struct.pack(">LB",value,0x40)
        self.cs.value(1)
        self.cs.value(0)    
        self.spi.write(cmd1)
        self.cs.value(1)
        self.cs.value(0)    
        self.spi.write(cmd2)
        while True:
	    self.cs.value(1)
            self.cs.value(0)    
            res=self.spi.read(5,0)
            if res[0] & 0x10:
                break
        if res[0] & 0x8 == 0:
            raise Exception("WB error")

    def read(self,adr):
        cmd1=struct.pack(">LB",adr,0x80)
        self.cs.value(1)
        self.cs.value(0)    
        self.spi.write(cmd1)
        while True:
	    self.cs.value(1)
            self.cs.value(0)    
            res=self.spi.read(5,0)
            if res[0] & 0x10:
                break
        if res[0] & 0x8 == 0:
            raise Exception("WB error")
        return struct.unpack(">BL",res)[1]    

    def __init__(self):
       self.spi = m.SPI(1,mosi=m.Pin(23),miso=m.Pin(19),sck=m.Pin(18))
       self.cs = m.Pin(5,m.Pin.OUT)

