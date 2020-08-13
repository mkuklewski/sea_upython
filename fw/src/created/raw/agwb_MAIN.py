from agwb import AwObj,AwSreg,AwCreg,AwBfd
class Agwb_DAC7311(AwObj):
    x__size = 4
    x__id = 0x2a2de91d
    x__ver = 0x762a56fb
    x__fields = {
        'ID':(0x0,(AwSreg,)),\
        'VER':(0x1,(AwSreg,)),\
        'Control':(0x2,(AwCreg,
        {\
            'WRITE':AwBfd(0,0,False),\
            'MODE':AwBfd(2,1,False),\
            'VALUE':AwBfd(14,3,False),\
            'clk_divider':AwBfd(30,15,False),\
        })),
        'Status':(0x3,(AwSreg,)),
    }
class Agwb_ADC1173(AwObj):
    x__size = 4
    x__id = 0xb6631a11
    x__ver = 0x762a56fb
    x__fields = {
        'ID':(0x0,(AwSreg,)),\
        'VER':(0x1,(AwSreg,)),\
        'Control':(0x2,(AwCreg,
        {\
            'ENABLE':AwBfd(0,0,False),\
            'clk_divider':AwBfd(16,1,False),\
        })),
        'ADC_Val':(0x3,(AwSreg,)),
    }
class Agwb_GEM(AwObj):
    x__size = 16
    x__id = 0xff7c43a
    x__ver = 0x762a56fb
    x__fields = {
        'ID':(0x0,(AwSreg,)),\
        'VER':(0x1,(AwSreg,)),\
        'CTRL_0':(0x2,(AwCreg,
        {\
            'ENABLE':AwBfd(0,0,False),\
            'OFFSET':AwBfd(14,1,False),\
            'THRESHOLD':AwBfd(28,15,False),\
        })),
        'CTRL_1':(0x3,(AwCreg,
        {\
            'MIN_PW':AwBfd(7,0,False),\
            'MAX_PW':AwBfd(15,8,False),\
            'TAIL':AwBfd(23,16,False),\
        })),
        'Error_too_short_cnt':(0x4,(AwSreg,)),
        'Error_too_long_cnt':(0x5,(AwSreg,)),
        'Error_negative_value_cnt':(0x6,(AwSreg,)),
        'Error_hist_bin_over_cnt':(0x7,(AwSreg,)),
        'Error_overlapping_cnt':(0x8,(AwSreg,)),
        'CTRL_2':(0x9,(AwCreg,
        {\
            'RESET_DPRAM_ADDRESS':AwBfd(0,0,False),\
        })),
        'BIN_VALUE':(0xa,(AwSreg,)),
        'OFFSET_READOUT':(0xb,(AwSreg,)),
        'FSM_STATE':(0xc,(AwSreg,)),
    }
class Agwb_MAIN(AwObj):
    x__size = 32
    x__id = 0x89bd20d0
    x__ver = 0x762a56fb
    x__fields = {
        'GEM':(0x0,1,(Agwb_GEM,)),\
        'ID':(0x10,(AwSreg,)),\
        'VER':(0x11,(AwSreg,)),\
        'CTRL':(0x12,(AwCreg,
        {\
            'rst_n':AwBfd(0,0,False),\
        })),
        'TEST_0':(0x13,(AwCreg,
        {\
            'ENABLE':AwBfd(0,0,False),\
            'VALUE':AwBfd(8,1,False),\
        })),
        'TEST_1':(0x14,(AwCreg,
        {\
            'PERIOD':AwBfd(15,0,False),\
            'PULSE_WIDHT':AwBfd(31,16,False),\
        })),
        'DAC7311':(0x18,1,(Agwb_DAC7311,)),\
        'ADC1173':(0x1c,1,(Agwb_ADC1173,)),\
    }
