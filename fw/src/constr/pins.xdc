#set_property IOSTANDARD LVCMOS33 [get_ports clk_io_i]
#set_property IOSTANDARD LVCMOS33 [get_ports rst_n_i]
#set_property PACKAGE_PIN N11 [get_ports clk_io_i]
#set_property PACKAGE_PIN A8 [get_ports rst_n_i]

set_property IOSTANDARD LVCMOS33 [get_ports clk_sys_i]
set_property PACKAGE_PIN H4 [get_ports clk_sys_i]

# LED
set_property IOSTANDARD LVCMOS33 [get_ports o_led]
set_property PACKAGE_PIN J1 [get_ports o_led]

# SPI
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property PACKAGE_PIN L14 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property PACKAGE_PIN P2 [get_ports spi_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports spi_sck]
set_property PACKAGE_PIN H14 [get_ports spi_sck]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {spi_sck_IBUF}]

set_property IOSTANDARD LVCMOS33 [get_ports spi_cs]
set_property PACKAGE_PIN M13 [get_ports spi_cs]


# Voltage defs for loading config.
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
