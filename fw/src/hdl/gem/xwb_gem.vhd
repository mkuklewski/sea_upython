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
  use work.agwb_GEM_wb_pkg.all;


entity xwb_GEM is
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
      
    slave_i       : in t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
    
    data_iv       : in std_logic_vector(7 downto 0);
    valid_i       : in std_logic;
    
    test_state_id_ov  : out std_logic_vector(2 downto 0)
    
  );    
end xwb_GEM;

architecture rtl of xwb_GEM is

    signal s_CTRL_0     : t_CTRL_0;
    signal s_CTRL_1     : t_CTRL_1;
    signal s_CTRL_2     : t_CTRL_2;
    
    
    signal s_enable     : std_logic;
    signal s_offset_val_v    : std_logic_vector(13 downto 0);
    signal s_threshold_val_v : std_logic_vector(13 downto 0);
    signal s_min_pw_v        : std_logic_vector(7 downto 0);
    signal s_max_pw_v        : std_logic_vector(7 downto 0);
    signal s_tail_samp_v     : std_logic_vector(7 downto 0);
    
    signal s_error_too_short_cnt_v          : std_logic_vector(15 downto 0);
    signal s_error_too_short_cnt_ack        : std_logic;
    signal s_error_too_long_cnt_v           : std_logic_vector(15 downto 0);
    signal s_error_too_long_cnt_ack         : std_logic;
    signal s_error_negative_value_cnt_v     : std_logic_vector(15 downto 0);
    signal s_error_negative_value_cnt_ack   : std_logic;
    signal s_error_hist_bin_over_cnt_v      : std_logic_vector(15 downto 0);
    signal s_error_hist_bin_over_cnt_ack    : std_logic;
    signal s_error_overlapping_cnt_v        : std_logic_vector(15 downto 0);
    signal s_error_overlapping_cnt_ack      : std_logic;
    signal s_BIN_VALUE_v                    : std_logic_vector(31 downto 0);
    signal s_BIN_VALUE_ack                  : std_logic;
    signal s_offset_readout_ov                    : std_logic_vector(14 downto 0);
    signal s_OFFSET_READOUT_v                    : signed(14 downto 0);
    signal s_OFFSET_READOUT_ack                  : std_logic;
    signal s_FSM_STATE_v                    : std_logic_vector(2 downto 0);
    signal s_FSM_STATE_ack                  : std_logic;
    signal s_rst_dpram_address              : std_logic;
    
    
    -- attribute MARK_DEBUG : string;
    -- attribute MARK_DEBUG of s_enable : signal is "TRUE";
    -- attribute MARK_DEBUG of s_data_v : signal is "TRUE";
    -- attribute MARK_DEBUG of s_valid : signal is "TRUE";
    -- attribute MARK_DEBUG of adc_data_iv : signal is "TRUE";
    -- attribute MARK_DEBUG of adc_clk_o : signal is "TRUE";
    -- attribute MARK_DEBUG of adc_en_o : signal is "TRUE";

begin

    
    
  cmp_agwb_GEM_wb : entity work.agwb_GEM_wb
    port map (
      slave_i => slave_i,
      slave_o => slave_o,

      CTRL_0_o  => s_CTRL_0,
      CTRL_1_o  => s_CTRL_1,
      CTRL_2_o  => s_CTRL_2,
      
      Error_too_short_cnt_i           => s_error_too_short_cnt_v,
      Error_too_short_cnt_i_ack       => s_error_too_short_cnt_ack,
      Error_too_long_cnt_i            => s_error_too_long_cnt_v,
      Error_too_long_cnt_i_ack        => s_error_too_long_cnt_ack,
      Error_negative_value_cnt_i      => s_error_negative_value_cnt_v,
      Error_negative_value_cnt_i_ack  => s_error_negative_value_cnt_ack,
      Error_hist_bin_over_cnt_i       => s_error_hist_bin_over_cnt_v,
      Error_hist_bin_over_cnt_i_ack   => s_error_hist_bin_over_cnt_ack,
      Error_overlapping_cnt_i         => s_error_overlapping_cnt_v,
      Error_overlapping_cnt_i_ack     => s_error_overlapping_cnt_ack,
      BIN_VALUE_i                     => s_BIN_VALUE_v,
      BIN_VALUE_i_ack                 => s_BIN_VALUE_ack,
      OFFSET_READOUT_i                => s_OFFSET_READOUT_v,
      OFFSET_READOUT_i_ack            => s_OFFSET_READOUT_ack,
      FSM_STATE_i                     => s_FSM_STATE_v,
      FSM_STATE_i_ack                 => s_FSM_STATE_ack,

      rst_n_i    => rst_n_i,
      clk_sys_i      => clk_i
    );
    
    
    s_OFFSET_READOUT_v <= signed(s_offset_readout_ov);
    
    s_enable          <= s_CTRL_0.ENABLE(0);
    s_offset_val_v    <= std_logic_vector(s_CTRL_0.OFFSET);
    s_threshold_val_v <= std_logic_vector(s_CTRL_0.THRESHOLD);
    
    s_min_pw_v        <= s_CTRL_1.MIN_PW;
    s_max_pw_v        <= s_CTRL_1.MAX_PW;
    s_tail_samp_v     <= s_CTRL_1.TAIL;
    
    s_rst_dpram_address     <= s_CTRL_2.RESET_DPRAM_ADDRESS(0);
    
    test_state_id_ov <= s_FSM_STATE_v;
    
  cmp_GEM : entity work.gem
    PORT MAP (
      clk_i      => clk_i,
      rst_n_i    => rst_n_i,
      
      enable_i      => s_enable,
      
      data_iv       => data_iv,
      valid_i       => valid_i,
      
      offset_val_iv     => s_offset_val_v,
      threshold_val_iv  => s_threshold_val_v,
      
      min_pw_iv         => s_min_pw_v,
      max_pw_iv         => s_max_pw_v,
      tail_samp_iv      => s_tail_samp_v,
      
      offset_readout_ov  => s_offset_readout_ov,
      
      test_state_id_ov  => s_FSM_STATE_v,
      
      error_too_short_cnt_ov          => s_error_too_short_cnt_v,
      error_too_short_cnt_ack_i       => s_error_too_short_cnt_ack,
      error_too_long_cnt_ov           => s_error_too_long_cnt_v,
      error_too_long_cnt_ack_i        => s_error_too_long_cnt_ack,
      error_negative_value_cnt_ov     => s_error_negative_value_cnt_v,
      error_negative_value_cnt_ack_i  => s_error_negative_value_cnt_ack,
      error_hist_bin_over_cnt_ov      => s_error_hist_bin_over_cnt_v,
      error_hist_bin_over_cnt_ack_i   => s_error_hist_bin_over_cnt_ack,
      error_overlapping_cnt_ov        => s_error_overlapping_cnt_v,
      error_overlapping_cnt_ack_i     => s_error_overlapping_cnt_ack,
      
      rst_dpram_address_i     => s_rst_dpram_address,
    
      bin_dpram_value_ov      => s_BIN_VALUE_v,
      bin_dpram_value_ack_i   => s_BIN_VALUE_ack
    
    );
    
    
    

end rtl;
