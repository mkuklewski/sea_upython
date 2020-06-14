#!/usr/bin/python3
from time import sleep
from umqtt.simple import MQTTClient
import spibus
import config
from agwb_MAIN import Agwb_MAIN,Agwb_ADC1173,Agwb_DAC7311

client = MQTTClient(config.SENSOR_ID, config.MQTT_HOST)
client.connect()

mif = spibus.spibus_iface()
a=Agwb_MAIN(mif,0)


print("Enable ADC")
a.ADC1173[0].Control.ENABLE.write(0x1)
print("Check ADC ENABLE:"+hex(a.ADC1173[0].Control.ENABLE.read()))
a.ADC1173[0].Control.clk_divider.write(0xA)
print("Check ADC Clock Divider:"+hex(a.ADC1173[0].Control.clk_divider.read()))

print("Enable DAC")
a.DAC7311[0].Control.MODE.write(0x0)

i = 0

while True:
    try:
        msg = hex(a.ADC1173[0].ADC_Val.read())
        print(msg)
        client.publish(config.MQTT_TOPIC, msg)
        
        a.DAC7311[0].Control.VALUE.write(i)
        a.DAC7311[0].Control.WRITE.write(0x1)
        a.DAC7311[0].Control.WRITE.write(0x0)
        i = i + 16
        if i > 2047:
            i = 0
    except OSError:
        print('Error')
    sleep(2)