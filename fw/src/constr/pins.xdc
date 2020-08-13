#set_property IOSTANDARD LVCMOS33 [get_ports clk_io_i]
#set_property PACKAGE_PIN N11 [get_ports clk_io_i]

# Reset
set_property IOSTANDARD LVCMOS33 [get_ports rst_n_i]
set_property PACKAGE_PIN D14 [get_ports rst_n_i]

set_property IOSTANDARD LVCMOS33 [get_ports clk_sys_i]
set_property PACKAGE_PIN H4 [get_ports clk_sys_i]

# ADC
set_property IOSTANDARD LVCMOS33 [get_ports adc_clk_o]
set_property PACKAGE_PIN C5 [get_ports adc_clk_o]

set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[7]}]
set_property PACKAGE_PIN H12 [get_ports {adc_data_iv[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[6]}]
set_property PACKAGE_PIN H11 [get_ports {adc_data_iv[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[5]}]
set_property PACKAGE_PIN C11 [get_ports {adc_data_iv[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[4]}]
set_property PACKAGE_PIN F12 [get_ports {adc_data_iv[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[3]}]
set_property PACKAGE_PIN E12 [get_ports {adc_data_iv[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[2]}]
set_property PACKAGE_PIN D12 [get_ports {adc_data_iv[2]}]
set_property PACKAGE_PIN J2 [get_ports {adc_data_iv[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[1]}]
set_property PACKAGE_PIN J3 [get_ports {adc_data_iv[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_data_iv[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports adc_en_o]
set_property PACKAGE_PIN J4 [get_ports adc_en_o]

# DAC
set_property IOSTANDARD LVCMOS33 [get_ports dac_clk_o]
set_property PACKAGE_PIN M1 [get_ports dac_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_data_o]
set_property PACKAGE_PIN L1 [get_ports dac_data_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_sync_n_o]
set_property PACKAGE_PIN N1 [get_ports dac_sync_n_o]

# LED 1
set_property IOSTANDARD LVCMOS33 [get_ports LED_1_o]
set_property PACKAGE_PIN J1 [get_ports LED_1_o]

# LED 2
set_property IOSTANDARD LVCMOS33 [get_ports LED_2_o]
set_property PACKAGE_PIN A13 [get_ports LED_2_o]

# SPI
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property PACKAGE_PIN L14 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property PACKAGE_PIN P2 [get_ports spi_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports spi_sck]
set_property PACKAGE_PIN H14 [get_ports spi_sck]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets spi_sck_IBUF]

set_property IOSTANDARD LVCMOS33 [get_ports spi_cs]
set_property PACKAGE_PIN M13 [get_ports spi_cs]

# DEBUG

# Voltage defs for loading config.
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]





connect_debug_port u_ila_0/probe1 [get_nets [list {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[0]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[1]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[2]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[3]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[4]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[5]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[6]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[7]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[8]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[9]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[10]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[11]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[12]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[13]} {cmp_xwb_GEM/cmp_GEM/offset_readout_ov[14]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list cmp_xwb_GEM/cmp_GEM/s_wea]]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets s_sys_clk]
