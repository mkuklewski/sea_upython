#!/usr/bin/python3
from time import sleep
from umqtt.robust import MQTTClient
import spibus
import config
import mqtt_topics
from agwb_MAIN import Agwb_MAIN,Agwb_ADC1173,Agwb_DAC7311

client = MQTTClient(config.MQTT_CLIENT_ID, config.MQTT_SERVER, config.MQTT_PORT, config.MQTT_USERNAME, config.MQTT_PASSWORD, 1)
client.connect()

mif = spibus.spibus_iface()
a = Agwb_MAIN(mif,0)

##### Main FPGA clock frequency is 100 MHz


##### Configure ADC
print("Configure ADC - to achieve 10 MHz write here 0x5")
a.ADC1173[0].Control.clk_divider.write(0x5)
print("Check ADC Clock Divider:"+hex(a.ADC1173[0].Control.clk_divider.read()))

print("Enable ADC")
a.ADC1173[0].Control.ENABLE.write(0x1)
print("Check ADC ENABLE:"+hex(a.ADC1173[0].Control.ENABLE.read()))
print("Enable ADC")



### Additional command
#Read current ADC value 
# value = a.ADC1173[0].ADC_Val.read()
# print("ADC Value:" + hex(value))


##### Configure DAC
print("Set DAC Mode")
a.DAC7311[0].Control.MODE.write(0x0)


##### Example usage
# print("Set DAC clock divider")
# a.DAC7311[0].Control.clk_divider.write(0x5)
# print("Write DAC value to send register")
# a.DAC7311[0].Control.VALUE.write(0x800)
# print("Write value to DAC7311")
# a.DAC7311[0].Control.WRITE.write(0x1)
# print("Stop writing value to DAC")
# a.DAC7311[0].Control.WRITE.write(0x0)


##### RESET FPGA - USE ONLY WHEN NEEDED  #####
# print("Reset FPGA")
# a.CTRL[0].rst_n.write(0x0)




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

##### Example usage of Test Data Generator
print("Set value")
a.TEST_0.VALUE.write(0xFF)
print("Set period - Amount of clock cycles after which Pulse will be repeated, 10ns base, 16bit resolution")
a.TEST_1.PERIOD.write(0x800)
print("Set period - Amount of clock cycles of the generated signal, must be less than period value, 10ns base, 16bit resolution")
a.TEST_1.PULSE_WIDHT.write(0x64)

print("Enable Test Data Generator -> Generated data will be send to ADC1173 input")
a.TEST_0.ENABLE.write(0x1)




while True:
    try:
        #check errors 
        value = a.GEM[0].Error_too_short_cnt.read()
        print("Error_too_short_cnt:" + hex(value))
        # if value > 0:
        try:
            client.publish(mqtt_topics.ERROR_TOO_SHORT_CNT, str(value))
        except OSError:
            print("Couldn't send ERROR_TOO_SHORT_CNT")
        
        value = a.GEM[0].Error_too_long_cnt.read()
        print("Error_too_long_cnt:" + hex(value))
        # if value > 0:    
        try:
            client.publish(mqtt_topics.ERROR_TOO_LONG_CNT, str(value))
        except OSError:
            print("Couldn't send ERROR_TOO_LONG_CNT")
        
        value = a.GEM[0].Error_negative_value_cnt.read()
        print("Error_negative_value_cnt:" + hex(value))
        # if value > 0:
        try:
            client.publish(mqtt_topics.ERROR_NEGATIVE_VALUE_CNT, str(value))
        except OSError:
            print("Couldn't send ERROR_NEGATIVE_VALUE_CNT")
        
            
        value = a.GEM[0].Error_hist_bin_over_cnt.read()
        print("Error_hist_bin_over_cnt:" + hex(value))
        # if value > 0:
        try:
            client.publish(mqtt_topics.ERROR_HIST_BIN_OVER_CNT, str(value))
        except OSError:
            print("Couldn't send ERROR_HIST_BIN_OVER_CNT")
        
            
        value = a.GEM[0].Error_overlapping_cnt.read()
        print("Error_overlapping_cnt:" + hex(value))
        # if value > 0:
        try:
            client.publish(mqtt_topics.ERROR_OVERLAPPING_CNT, str(value))
        except OSError:
            print("Couldn't send ERROR_OVERLAPPING_CNT")
        
        
        ## Reset DPRAM Address to 0 - not necessary, because we read same amount of data all the time 
        a.GEM[0].CTRL_2.RESET_DPRAM_ADDRESS.write(0x1)
        a.GEM[0].CTRL_2.RESET_DPRAM_ADDRESS.write(0x0)
        
        ## LOW ENERGY
        x = 0
        for i in range (0, 85):
            x += a.GEM[0].BIN_VALUE.read()
        
        # if x > 0:
        try:
            client.publish(mqtt_topics.LOW_ENERGY, str(x))
        except OSError:
            print("Couldn't send LOW_ENERGY")
        
        print("LOW_ENERGY:" + str(x))
        
        ## MEDIUM ENERGY
        x = 0
        for i in range (86, 172):
            x += a.GEM[0].BIN_VALUE.read()
        
        
        # if x > 0:
        try:
            client.publish(mqtt_topics.MEDIUM_ENERGY, str(x))
        except OSError:
            print("Couldn't send MEDIUM_ENERGY")
        
        print("MEDIUM_ENERGY:" + str(x))
        
        ## HIGH ENERGY
        x = 0
        for i in range (173, 255):
            x += a.GEM[0].BIN_VALUE.read()
        
        
        # if x > 0:
        try:
            client.publish(mqtt_topics.HIGH_ENERGY, str(x))
        except OSError:
            print("Couldn't send HIGH_ENERGY")
        
        print("HIGH_ENERGY:" + str(x))
        
        ##### Added OFFSET Readout and FSM State
        
        
        x = a.GEM[0].OFFSET_READOUT.read()
        print("OFFSET_READOUT:" + hex(x))
        
        x = a.GEM[0].FSM_STATE.read()
        print("FSM_STATE:" + hex(x))
        
        print("------------------------------------")
    
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
    sleep(config.SLEEP_TIME)