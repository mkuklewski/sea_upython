: // $0 ;
: //#GEM // $0 + swap $10 * + ;
: //#GEM_ID //#GEM $0 + ;
: //#GEM_VER //#GEM $1 + ;
$ff7c43a constant //#GEM_ID_VAL 
$762a56fb constant //#GEM_VER_VAL 
: //#GEM_CTRL_0 //#GEM $2 + ;
: //#GEM_CTRL_0.ENABLE //#GEM_CTRL_0 $1 $0 ;
: //#GEM_CTRL_0.OFFSET //#GEM_CTRL_0 $7ffe $1 ;
: //#GEM_CTRL_0.THRESHOLD //#GEM_CTRL_0 $1fff8000 $f ;
: //#GEM_CTRL_1 //#GEM $3 + ;
: //#GEM_CTRL_1.MIN_PW //#GEM_CTRL_1 $ff $0 ;
: //#GEM_CTRL_1.MAX_PW //#GEM_CTRL_1 $ff00 $8 ;
: //#GEM_CTRL_1.TAIL //#GEM_CTRL_1 $ff0000 $10 ;
: //#GEM_Error_too_short_cnt //#GEM $4 + ;
: //#GEM_Error_too_long_cnt //#GEM $5 + ;
: //#GEM_Error_negative_value_cnt //#GEM $6 + ;
: //#GEM_Error_hist_bin_over_cnt //#GEM $7 + ;
: //#GEM_Error_overlapping_cnt //#GEM $8 + ;
: //#GEM_CTRL_2 //#GEM $9 + ;
: //#GEM_CTRL_2.RESET_DPRAM_ADDRESS //#GEM_CTRL_2 $1 $0 ;
: //#GEM_BIN_VALUE //#GEM $a + ;
: //#GEM_OFFSET_READOUT //#GEM $b + ;
: //#GEM_FSM_STATE //#GEM $c + ;
: //_ID // $10 + ;
: //_VER // $11 + ;
$89bd20d0 constant //_ID_VAL 
$762a56fb constant //_VER_VAL 
: //_CTRL // $12 + ;
: //_CTRL.rst_n //_CTRL $1 $0 ;
: //_TEST_0 // $13 + ;
: //_TEST_0.ENABLE //_TEST_0 $1 $0 ;
: //_TEST_0.VALUE //_TEST_0 $1fe $1 ;
: //_TEST_1 // $14 + ;
: //_TEST_1.PERIOD //_TEST_1 $ffff $0 ;
: //_TEST_1.PULSE_WIDHT //_TEST_1 $ffff0000 $10 ;
: //#DAC7311 // $18 + swap $4 * + ;
: //#DAC7311_ID //#DAC7311 $0 + ;
: //#DAC7311_VER //#DAC7311 $1 + ;
$2a2de91d constant //#DAC7311_ID_VAL 
$762a56fb constant //#DAC7311_VER_VAL 
: //#DAC7311_Control //#DAC7311 $2 + ;
: //#DAC7311_Control.WRITE //#DAC7311_Control $1 $0 ;
: //#DAC7311_Control.MODE //#DAC7311_Control $6 $1 ;
: //#DAC7311_Control.VALUE //#DAC7311_Control $7ff8 $3 ;
: //#DAC7311_Control.clk_divider //#DAC7311_Control $7fff8000 $f ;
: //#DAC7311_Status //#DAC7311 $3 + ;
: //#ADC1173 // $1c + swap $4 * + ;
: //#ADC1173_ID //#ADC1173 $0 + ;
: //#ADC1173_VER //#ADC1173 $1 + ;
$b6631a11 constant //#ADC1173_ID_VAL 
$762a56fb constant //#ADC1173_VER_VAL 
: //#ADC1173_Control //#ADC1173 $2 + ;
: //#ADC1173_Control.ENABLE //#ADC1173_Control $1 $0 ;
: //#ADC1173_Control.clk_divider //#ADC1173_Control $1fffe $1 ;
: //#ADC1173_ADC_Val //#ADC1173 $3 + ;
