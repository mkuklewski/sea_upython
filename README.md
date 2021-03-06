# sea_upython
This project contains simple FPGA firmware and Python scripts allowing you to use efficiently MicroPython on a
[Spartan Edge Accelerator](https://wiki.seeedstudio.com/Spartan-Edge-Accelerator-Board/) board.

The directory "fw" contains sources of the FPGA firmware. You should first run the "prepare.sh" script to download necessary components,
then the "generate.sh" script generates the code providing access to the complex tree of blocks and registers
created in the FPGA. Finally the "build.sh" script builds the FPGA configuration bitstream using the Vivado tool (it must be in path!).

I have installed the MicroPython to the SEA board with the following procedure(for Windows user - change "/dev/ttyUSB1" to proper "COM" port):

    wget https://micropython.org/resources/firmware/esp32-idf3-20191220-v1.12.bin
    esptool.py --chip esp32 --port /dev/ttyUSB1 erase_flash
    esptool.py --chip esp32 --port /dev/ttyUSB1 --baud 460800 write_flash -z 0x1000 esp32-idf3-20191220-v1.12.bin

In the "Python" directory there are the files that should be placed in the FLASH filesystem, after the MicroPython is installed.
I have done it using the ampy tool:

    ampy -d 3 -p /dev/ttyUSB1 put boot.py /boot.py
    ampy -d 3 -p /dev/ttyUSB1 put main.py /main.py

The files from "Python/sd" directory should be copied to the SD card.
You should also copy to the main directory on the SD card the following files (they will be created after the successful compilation):

*  /fw/src/created/raw/agwb_MAIN.py 
*  /fw/src/created/raw/agwb_MAIN_const.py 
*  /fw/sea_wb_ag/sea_wb_ag.runs/impl_1/main.bit
*  /modules/addr_gen_wb/python-support/agwb.py

If you place the SD into the socket and switch on the SEA board, you should see the following:

```
MicroPython v1.12 on 2019-12-20; ESP32 module with ESP32
Type "help()" for more information.
>>> 
>>> 
I (626270) gpio: GPIO[15]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
I (626270) gpio: GPIO[2]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
I (626280) gpio: GPIO[14]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
MPY: soft reboot
E (627360) sdmmc_common: sdmmc_init_ocr: send_op_cond (1) returned 0x107
I (627360) gpio: GPIO[13]| InputEn: 0| OutputEn: 1| OpenDrain: 0| Pullup: 0| Pulldown: 0| Intr:0 
['README', 'loader.py', 'main_sd.py', 'spibus.py', 'wb_test.py', 'agwb.py', 'agwb_MAIN.py', 'agwb_MAIN_const.py', 'main.bit']
9
1
b'a'
40
Design: main;UserID=0XFFFFFFFF;Version=2019.1.1
b'b'
12
Part: 7s15ftgb196
b'c'
11                                                                                           
Date: 2020/05/20                                                                             
b'd'                                                                                         
9                                                                                            
Time: 20:12:43
b'e'
538844
I (627560) gpio: GPIO[23]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
I (627570) gpio: GPIO[19]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
I (627580) gpio: GPIO[18]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
FPGA start reset
FPGA end reset
FPGA Configuration: Success
Configuration took: 3 seconds.
I (631050) gpio: GPIO[27]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
I (631050) gpio: GPIO[17]| InputEn: 0| OutputEn: 0| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0 
Test the ID
ID read:0x89bd20d0
VER read:0x6a45b3f2
LINKS0 ID read:0x5bd964c2
LINKS0 VER read:0x6a45b3f2
LINKS0 STATUS read:0x0
Initial value of MAIN.CTRL:0x0
LINKS0 CTRL.START write
LINKS4 STATUS read:0x0
Now we test bitfields
LINKS4 CTRL.START write
Now we test the blackbox
EXTERN[0] REG1 read:0x56780001
EXTERN[1] REG2 read:0x56780402
And again we read the LINKS1 ID and version
LINKS1 ID read:0x5bd964c2
LINKS1 VER read:0x6a45b3f2
Traceback (most recent call last):
  File "main.py", line 11, in <module>
  File "main_sd.py", line 2, in <module>
  File "wb_test.py", line 33, in <module>
  File "agwb.py", line 121, in __getattr__
KeyError: TEST_OUT
MicroPython v1.12 on 2019-12-20; ESP32 module with ESP32
Type "help()" for more information.
```

The final error is expected, because the `TEST_OUT` register is not available.
The tree of blocks and registers is conveniently mapped inot the hierarchy of Python classes and objects, 
generated by the [AGWB](https://github.com/wzab/addr_gen_wb) tool. Take a look at the `wb_test.py` file to see how it can be used.
