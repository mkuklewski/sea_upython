#!/usr/bin/python3
from time import sleep
from umqtt.simple import MQTTClient
import spibus
import config
import mqtt_topics
from agwb_MAIN import Agwb_MAIN,Agwb_ADC1173,Agwb_DAC7311

client = MQTTClient(config.SENSOR_ID, config.MQTT_HOST)
client.connect()

mif = spibus.spibus_iface()
a = Agwb_MAIN(mif,0)

##### Configure ADC
print("Enable ADC")
a.ADC1173[0].Control.ENABLE.write(0x1)
print("Check ADC ENABLE:"+hex(a.ADC1173[0].Control.ENABLE.read()))
a.ADC1173[0].Control.clk_divider.write(0xA)
print("Check ADC Clock Divider:"+hex(a.ADC1173[0].Control.clk_divider.read()))

##### Configure DAC
print("Enable DAC")
a.DAC7311[0].Control.MODE.write(0x0)

##### Configure GEM IP Core

print("Set OFFSET Value")
a.GEM[0].CTRL_0.OFFSET.write(0x10)
print("Set THRESHOLD Value")
a.GEM[0].CTRL_0.THRESHOLD.write(0x15)
print("Set MIN_PW Value")
a.GEM[0].CTRL_1.MIN_PW.write(0x8)
print("Set MAX_PW Value")
a.GEM[0].CTRL_1.MAX_PW.write(0x20)
print("Set TAIL Value")
a.GEM[0].CTRL_1.TAIL.write(0x4)


print("Enable GEM")
a.GEM[0].CTRL_0.ENABLE.write(0x1)




while True:
    try:
        #check errors 
        value = a.GEM[0].Error_too_short_cnt.read()
        if value > 0:
            client.publish(mqtt_topics.ERROR_TOO_SHORT_CNT, hex(value))
            
        value = a.GEM[0].Error_too_long_cnt.read()
        if value > 0:
            client.publish(mqtt_topics.ERROR_TOO_LONG_CNT, hex(value))
            
        value = a.GEM[0].Error_negative_value_cnt.read()
        if value > 0:
            client.publish(mqtt_topics.ERROR_NEGATIVE_VALUE_CNT, hex(value))
            
        value = a.GEM[0].Error_hist_bin_over_cnt.read()
        if value > 0:
            client.publish(mqtt_topics.ERROR_HIST_BIN_OVER_CNT, hex(value))
            
        value = a.GEM[0].Error_overlapping_cnt.read()
        if value > 0:
            client.publish(mqtt_topics.ERROR_OVERLAPPING_CNT, hex(value))
        
        ## Reset DPRAM Address to 0 - not necessary, because we read same amount of data all the time 
        a.GEM[0].CTRL_2.RESET_DPRAM_ADDRESS.write(0x1)
        a.GEM[0].CTRL_2.RESET_DPRAM_ADDRESS.write(0x0)
        
        ## LOW ENERGY
        x = 0
        for i in range (0, 85):
            x += a.GEM[0].BIN_VALUE.read()
        
        if x > 0:
            client.publish(mqtt_topics.LOW_ENERGY, hex(x))
            print("LOW_ENERGY:" + hex(x))
        
        ## MEDIUM ENERGY
        x = 0
        for i in range (86, 172):
            x += a.GEM[0].BIN_VALUE.read()
        
        
        if x > 0:
            client.publish(mqtt_topics.MEDIUM_ENERGY, hex(x))
            print("MEDIUM_ENERGY:" + hex(x))
        
        ## HIGH ENERGY
        x = 0
        for i in range (173, 255):
            x += a.GEM[0].BIN_VALUE.read()
        
        
        if x > 0:
            client.publish(mqtt_topics.HIGH_ENERGY, hex(x))
            print("HIGH_ENERGY:" + hex(x))
        
    
    
        # msg = hex(a.ADC1173[0].ADC_Val.read())
        # print(msg)
        # client.publish(config.MQTT_TOPIC, msg)
        
        # a.DAC7311[0].Control.VALUE.write(i)
        # a.DAC7311[0].Control.WRITE.write(0x1)
        # a.DAC7311[0].Control.WRITE.write(0x0)
        # i = i + 16
        # if i > 2047:
            # i = 0
    except OSError:
        print('OS Error!!!!')
    sleep(1)