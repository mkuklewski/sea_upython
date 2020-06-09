#!/usr/bin/python3
import spibus
from agwb_MAIN import Agwb_MAIN,Agwb_ADC1173,Agwb_DAC7311
mif = spibus.spibus_iface()
a=Agwb_MAIN(mif,0)
print("Test the ID")
print ("ID read:"+ hex(a.ID.read()))
print ("VER read:"+ hex(a.VER.read()))
print("Test the ADC ID")
print ("ID read:"+ hex(a.ADC1173[0].ID.read()))
print ("VER read:"+ hex(a.ADC1173[0].VER.read()))
print("Test the DAC ID")
print ("ID read:"+ hex(a.DAC7311[0].ID.read()))
print ("VER read:"+ hex(a.DAC7311[0].VER.read()))


print("Enable ADC")
a.ADC1173[0].Control.ENABLE.write(0x1)
print("Check ADC ENABLE:"+hex(a.ADC1173[0].Control.ENABLE.read()))
a.ADC1173[0].Control.clk_divider.write(0xA)
print("Check ADC Clock Divider:"+hex(a.ADC1173[0].Control.clk_divider.read()))

print("Check ADC Value:"+hex(a.ADC1173[0].ADC_Val.read()))



print("Enable DAC")
a.DAC7311[0].Control.MODE.write(0x0)
print("Check DAC MODE:"+hex(a.ADC1173.Control.MODE.read()))
a.DAC7311[0].Control.VALUE.write(0x3FF)
print("Check DAC VALUE:"+hex(a.DAC7311[0].Control.VALUE.read()))
a.DAC7311[0].Control.WRITE.write(0x1)
print("Check DAC WRITE:"+hex(a.DAC7311[0].Control.WRITE.read()))
a.DAC7311[0].Control.WRITE.write(0x0)
print("Check DAC WRITE:"+hex(a.DAC7311[0].Control.WRITE.read()))

print("Check ADC Value:"+hex(a.ADC1173[0].ADC_Val.read()))




