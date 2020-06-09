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
  use work.agwb_DAC7311_wb_pkg.all;


entity xwb_DAC7311 is
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
      
    slave_i       : in t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
    
    dac_data_o    : out std_logic;
    dac_clk_o     : out std_logic;
    dac_sync_n_o  : out std_logic
    
  );    
end xwb_DAC7311;

architecture rtl of xwb_DAC7311 is

    signal s_CTRL     : t_Control;
    
    
    signal s_done     : std_logic;
    signal s_write    : std_logic;
    signal s_mode_v   : std_logic_vector(1 downto 0);
    signal s_data_v   : std_logic_vector(11 downto 0);
    signal s_clk_divider_v   : std_logic_vector(15 downto 0);
    
    
    attribute MARK_DEBUG : string;
    attribute MARK_DEBUG of s_write : signal is "TRUE";
    attribute MARK_DEBUG of s_mode_v : signal is "TRUE";
    attribute MARK_DEBUG of s_data_v : signal is "TRUE";
    attribute MARK_DEBUG of s_done : signal is "TRUE";
				
    
    
    

begin

    
    
  cmp_agwb_DAC7311_wb : entity work.agwb_DAC7311_wb 
    port map (
      slave_i => slave_i,
      slave_o => slave_o,

      Control_o     => s_CTRL,
      Control_o_stb  => open,
      Status_i(0)     => s_done,
      Status_i_ack => open,

      rst_n_i    => rst_n_i,
      clk_sys_i      => clk_i
      );
    
    
    
    
    s_write   <= s_CTRL.write(0);
    s_mode_v  <= s_CTRL.mode;
    s_data_v  <= s_CTRL.value;
    s_clk_divider_v  <= s_CTRL.clk_divider;
    
    
  cmp_DAC7311 : entity work.DAC7311
    PORT MAP (
      clk_i      => clk_i,
      rst_n_i    => rst_n_i,
      
      
      write_i       => s_write,
      mode_iv       => s_mode_v,       -- PD1  PD0   OPERATING MODE
                                                          --   0    0   Normal Operation
                                                          --   0    1   Output 1 kΩ to GND
                                                          --   1    0   Output 100 kΩ to GND
                                                          --   1    1   High-Z
      data_iv       => s_data_v, 
      clk_divider_iv       => s_clk_divider_v, 
      done_o        => s_done,
      
      dac_data_o    => dac_data_o,
      dac_clk_o     => dac_clk_o,
      dac_sync_n_o  => dac_sync_n_o
      
      
    
    );
    
    

end rtl;
