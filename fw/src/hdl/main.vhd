----------------------------------------------------------------------------------
-- Creator: Michal Kuklewski 
-- Create Date: 23.05.2020 00:22:38
-- 
--  TO DO
--  1. Project generation with proper constrains                  - done
--  2. Implement onboard DAC and ADC with Wishbone interface      - done
--  3. Implement Xilinx Chipscope                                 - done
--  4. Implement VIO 32 bit IN + 32 bit OUT                       - done
--  5. SPI interface to ESP32 (with possible upgrade to QSPI)     - SPI done
--  6. RAM Memory 32bit * min 2k
--  7. Control registers - 8x 32 bit                              - done
--  8. MicroPython Support                                        - done
--  9. MQTT                             - require more specification
-- 10. Memory Read/Write                - require more specification
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
    
    -- LED outputs 
    LED_1_o       : out std_logic;
    LED_2_o       : out std_logic;
    
    -- SPI interface
    spi_miso  : out std_logic;
    spi_mosi  : in  std_logic;
    spi_sck   : in  std_logic;
    spi_cs    : in  std_logic;
    
    -- ADC 1173 Innterface
    adc_en_o      : out std_logic;
    adc_clk_o     : out std_logic;
    adc_data_iv   : in std_logic_vector(7 downto 0);
    
    -- DAC 7311 Innterface
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
  signal GEM_wb_m_o                                   : t_wishbone_master_out_array(0 to 0);
  signal GEM_wb_m_i                                   : t_wishbone_master_in_array(0 to 0);
  signal CTRL_o                                       : t_CTRL;
  
  -- signal REG_o            : t_REG_array;
  signal s_reg_v          : std_logic_vector(31 downto 0);
  
  signal s_data_v       : std_logic_vector(7 downto 0);
  signal s_valid       : std_logic;

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
      GEM_wb_m_o      => GEM_wb_m_o,
      GEM_wb_m_i      => GEM_wb_m_i,
      DAC7311_wb_m_o  => DAC7311_wb_m_o,
      DAC7311_wb_m_i  => DAC7311_wb_m_i,
      ADC1173_wb_m_o  => ADC1173_wb_m_o,
      ADC1173_wb_m_i  => ADC1173_wb_m_i,
      CTRL_o        => CTRL_o,
      -- REG_o         => REG_o,
      rst_n_i       => s_sys_rst_n,
      clk_sys_i     => clk_sys_i
    );
    
    -- Example how to access registers (need to change signal name !!!)
    -- s_reg_v <= REG_o(0);
    -- s_reg_v <= REG_o(1);
    -- s_reg_v <= REG_o(2);
    -- s_reg_v <= REG_o(3);
    -- s_reg_v <= REG_o(4);
    -- s_reg_v <= REG_o(5);
    -- s_reg_v <= REG_o(6);
    -- s_reg_v <= REG_o(7);



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
      
      
      data_ov    => s_data_v,
      valid_o    => s_valid,
      
      
      adc_en_o    => adc_en_o,
      adc_clk_o   => adc_clk_o,
      adc_data_iv => adc_data_iv
    );

  cmp_xwb_GEM : entity work.xwb_GEM
    PORT MAP (
      clk_i      => s_sys_clk,
      rst_n_i    => s_sys_rst_n,
      
      
      slave_i    => GEM_wb_m_o(0),
      slave_o    => GEM_wb_m_i(0),
      
      
      data_iv    => s_data_v,
      valid_i    => s_valid,
      
      test_state_id_ov  => open
    );
    
  
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
