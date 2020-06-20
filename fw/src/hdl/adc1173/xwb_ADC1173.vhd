----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2020 18:55:57
-- Design Name: 
-- Module Name: DAC7311 - rtl
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
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

  library general_cores;
  use general_cores.wishbone_pkg.all;
  library work;
  use work.agwb_ADC1173_wb_pkg.all;


entity xwb_ADC1173 is
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
      
    slave_i       : in t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
    
    data_ov       : out std_logic_vector(7 downto 0);
    valid_o       : out std_logic;
    
    adc_en_o      : out std_logic;
    adc_clk_o     : out std_logic;
    adc_data_iv   : in std_logic_vector(7 downto 0)
    
  );    
end xwb_ADC1173;

architecture rtl of xwb_ADC1173 is

    signal s_CTRL     : t_Control;
    
    
    signal s_enable     : std_logic;
    signal s_valid     : std_logic;
    signal s_data_v   : std_logic_vector(7 downto 0);
    signal s_clk_divider_v   : std_logic_vector(15 downto 0);
    
    attribute MARK_DEBUG : string;
    attribute MARK_DEBUG of s_enable : signal is "TRUE";
    attribute MARK_DEBUG of s_data_v : signal is "TRUE";
    attribute MARK_DEBUG of s_valid : signal is "TRUE";
    attribute MARK_DEBUG of adc_data_iv : signal is "TRUE";
    attribute MARK_DEBUG of adc_clk_o : signal is "TRUE";
    attribute MARK_DEBUG of adc_en_o : signal is "TRUE";

begin

    
    
  cmp_agwb_ADC1173_wb : entity work.agwb_ADC1173_wb 
    port map (
      slave_i => slave_i,
      slave_o => slave_o,

      Control_o     => s_CTRL,
      Control_o_stb  => open,
      ADC_Val_i     => s_data_v,
      ADC_Val_i_ack => open,

      rst_n_i    => rst_n_i,
      clk_sys_i      => clk_i
      );
    
    
    
    
    s_enable          <= s_CTRL.ENABLE(0);
    s_clk_divider_v   <= std_logic_vector(s_CTRL.clk_divider);
    
    
  cmp_ADC1173 : entity work.ADC1173
    -- generic map(
      -- g_system_clock  => 100000000,
      -- g_sampling_rate => 15000000 
    -- )
    PORT MAP (
      clk_i      => clk_i,
      rst_n_i    => rst_n_i,
      
      enable_i    => s_enable,
      clk_divider_iv    => s_clk_divider_v,
      
      adc_en_o      => adc_en_o,
      adc_clk_o     => adc_clk_o,
      adc_data_iv   => adc_data_iv,
     
      data_ov     => s_data_v,
      valid_o     => s_valid
      
      
    
    );
    
    data_ov <= s_data_v;
    valid_o <= s_valid;
    
    
    
    
    

end rtl;
