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

