----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2020 00:22:38
-- Design Name: 
-- Module Name: top - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--  FIRST TO DO
--  - projekt z constraintami     -- done
--  
--  - wejście dla ADC 14bit, 10MS/s, 14bit dane, wyjście zegara, 3V3    
--  
--  - chipscope zaimplementowany jawnym kodem, obsluga ADC + dodatkowej magistrali 16bit  
--  
--  - VIO 32 bit we + 32 bit WY                                                            -- done
--
--
--
--
--
--- interfejs SPI do ESP32, najlepiej QSPI, ale na razie może być SPI.    -- partialy done
--
--- pamięć RAM 32bit * min 2k
--
--- zestaw rejestrow, powiedzmy 8x 32 bit
--
--- wsparcie dla micropythona, MQTT, odczyt/zapis pamięci RAM,  zapis/odczyt rejestrow
--
--
--
--
--
--
--
--
--
--
----------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library general_cores;
use general_cores.wishbone_pkg.all;
library work;
use work.agwb_MAIN_wb_pkg.all;
-- use work.agwb_DAC7311_wb_pkg.all;

entity main is

  port (
    rst_n_i   : in  std_logic;
    clk_sys_i : in  std_logic;
    
    
    LED_1_o       : out std_logic;
    LED_2_o       : out std_logic;
    
    
    --clk_io_i  : in  std_logic;
    
    -- o_led     : out std_logic;
    -- SPI interface
    spi_miso  : out std_logic;
    spi_mosi  : in  std_logic;
    spi_sck   : in  std_logic;
    spi_cs    : in  std_logic;
    
    adc_en_o      : out std_logic;
    adc_clk_o     : out std_logic;
    adc_data_iv   : in std_logic_vector(7 downto 0);
    
    dac_data_o    : out std_logic;
    dac_clk_o     : out std_logic;
    dac_sync_n_o  : out std_logic
    
    
    
    
    
    );

end entity main;

architecture rtl of main is

  signal s_sys_clk        : std_logic;
  signal s_pll_locked     : std_logic;
  signal s_sys_rst_n      : std_logic;
  signal s_rst_cnt        : integer range 0 to 100000 := 100000;

  signal s_probe_in_v     : std_logic_vector(31 downto 0);
  signal s_probe_out_v    : std_logic_vector(31 downto 0);


  signal wb_s_in                                      : t_wishbone_slave_in;
  signal wb_s_out                                     : t_wishbone_slave_out;
  signal LINKS_wb_m_o                                 : t_wishbone_master_out_array(0 to 4);
  signal LINKS_wb_m_i                                 : t_wishbone_master_in_array(0 to 4);
  signal EXTERN_wb_m_o                                : t_wishbone_master_out_array(0 to 2);
  signal EXTERN_wb_m_i                                : t_wishbone_master_in_array(0 to 2);
  signal DAC7311_wb_m_o                                   : t_wishbone_master_out_array(0 to 0);
  signal DAC7311_wb_m_i                                   : t_wishbone_master_in_array(0 to 0);
  signal ADC1173_wb_m_o                                   : t_wishbone_master_out_array(0 to 0);
  signal ADC1173_wb_m_i                                   : t_wishbone_master_in_array(0 to 0);
  signal CTRL_o                                       : t_CTRL;
  -- signal rst_sys_0, rst_sys_n_i, rst_io_0, rst_io_n_i : std_logic;
  -- signal clk_io_i                                     : std_logic;
  -- signal rst_n_i                                      : std_logic                 := '0';
  
  

  -- attribute ASYNC_REG                                                 : string;
  -- attribute ASYNC_REG of rst_sys_0, rst_sys_n_i, rst_io_0, rst_io_n_i : signal is "TRUE";
  
  
  
begin  -- architecture rtl

  s_probe_in_v <= s_probe_out_v;


  -- clk_io_i <= clk_sys_i;
  --o_led <= rst_n_i;

  LED_2_o <= '0';

  cmp_clk_wiz_0 : entity work.clk_wiz_0
     port map ( 
    -- Clock out ports  
     clk_out1 => s_sys_clk,
    -- Status and control signals                
     resetn => rst_n_i,
     locked => s_pll_locked,
     -- Clock in ports
     clk_in1 => clk_sys_i
   );


  -- generation of reset
  process (s_sys_clk) is
  begin  -- process
    if rising_edge(s_sys_clk) then  -- rising clock edge
      if (s_pll_locked = '1') then
        if s_rst_cnt > 0 then
          s_sys_rst_n <= '0';
          s_rst_cnt <= s_rst_cnt - 1;
        else
          s_sys_rst_n <= '1';
        end if;
      else
        s_rst_cnt <= 100000;
      end if;
    end if;
  end process;


  spi2wb_1 : entity work.spi2wb
    generic map (
      addr_width => 32,
      data_width => 32)
    port map (
      o_led          => LED_1_o,
      spi_miso       => spi_miso,
      spi_mosi       => spi_mosi,
      spi_sck        => spi_sck,
      spi_cs         => spi_cs,
      master_clk_i   => s_sys_clk,
      master_rst_n_i => s_sys_rst_n,
      master_i       => wb_s_out,
      master_o       => wb_s_in
    );

  MAIN_wb_1 : entity work.agwb_MAIN_wb
    port map (
      slave_i       => wb_s_in,
      slave_o       => wb_s_out,
      DAC7311_wb_m_o  => DAC7311_wb_m_o,
      DAC7311_wb_m_i  => DAC7311_wb_m_i,
      ADC1173_wb_m_o  => ADC1173_wb_m_o,
      ADC1173_wb_m_i  => ADC1173_wb_m_i,
      CTRL_o        => CTRL_o,
      rst_n_i       => s_sys_rst_n,
      clk_sys_i     => clk_sys_i
    );



  cmp_xwb_DAC7311 : entity work.xwb_DAC7311
    PORT MAP (
      clk_i      => s_sys_clk,
      rst_n_i    => s_sys_rst_n,
      
      
      slave_i    => DAC7311_wb_m_o(0),
      slave_o    => DAC7311_wb_m_i(0),
      
      
      dac_data_o  => dac_data_o,
      dac_clk_o   => dac_clk_o,
      dac_sync_n_o  => dac_sync_n_o
      
      
    
    );

  cmp_xwb_ADC1173 : entity work.xwb_ADC1173
    PORT MAP (
      clk_i      => s_sys_clk,
      rst_n_i    => s_sys_rst_n,
      
      
      slave_i    => ADC1173_wb_m_o(0),
      slave_o    => ADC1173_wb_m_i(0),
      
      
      adc_en_o    => adc_en_o,
      adc_clk_o   => adc_clk_o,
      adc_data_iv => adc_data_iv
      
      
    
    );



  -- gl0 : for i in 0 to 2 generate
    -- wb_cdc_1 : entity work.wb_cdc
      -- generic map (
        -- width => 32)
      -- port map (
        -- slave_clk_i    => clk_sys_i,
        -- slave_rst_n_i  => rst_sys_n_i,
        -- slave_i        => CDC_wb_m_o(i),
        -- slave_o        => CDC_wb_m_i(i),
        -- master_clk_i   => clk_io_i,
        -- master_rst_n_i => rst_io_n_i,
        -- master_i       => EXTERN_wb_m_i(i),
        -- master_o       => EXTERN_wb_m_o(i));

    -- ext_1 : entity work.exttest
      -- generic map (
        -- instance_number => 1,
        -- addr_size       => 10
        -- )
      -- port map (
        -- rst_n_i   => rst_io_n_i,
        -- clk_sys_i => clk_io_i,
        -- wb_s_in   => EXTERN_wb_m_o(i),
        -- wb_s_out  => EXTERN_wb_m_i(i));

  -- end generate gl0;

  -- gl1 : for i in 0 to 4 generate

    -- sys1_1 : entity work.sys1
      -- port map (
        -- rst_n_i   => rst_sys_n_i,
        -- clk_sys_i => clk_sys_i,
        -- wb_s_in   => LINKS_wb_m_o(i),
        -- wb_s_out  => LINKS_wb_m_i(i));

  -- end generate gl1;
  
  -----------------------------------------------------------------------------
  -- Debug
  -----------------------------------------------------------------------------

  cmp_vio_0 : entity work.vio_0
    PORT MAP (
      clk => s_sys_clk,
      probe_in0 => s_probe_in_v,
      probe_out0 => s_probe_out_v
    );
  
  
  -- cmp_ila_0 : entity work.ila_0
  -- PORT MAP (
    -- clk => clk,

    -- probe0 => probe0, 
    -- probe1 => probe1, 
    -- probe2 => probe2,
    -- probe3 => probe3
  -- );

end architecture rtl;
