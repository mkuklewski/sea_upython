----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.06.2020 01:06:52
-- Design Name: 
-- Module Name: GEM_TB - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GEM_TB is
--  Port ( );
end GEM_TB;

architecture Behavioral of GEM_TB is

  signal clk : std_logic;
  signal rst_n : std_logic;



  signal enable : std_logic;



  signal data_v   : std_logic_vector(7 downto 0);
  signal valid  : std_logic;

  signal i : integer := 0;


begin

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;


  rst_n <= '0', '1' after 100 ns;


  enable <= '0', '1' after 200 ns;

  data_v  <= x"ff", x"00" after 3 us;
  

    -- Save data 
    process 
    begin
        valid   <= '0';
        wait for 250 ns;
        
        for i in 0 to 120 loop
          valid   <= '1';
          wait for 10 ns;
          valid   <= '0';
          wait for 100 ns;
        
        end loop;
        
        -- if (i = 30) then
          -- wait for 10 ns;
        
          -- valid   <= '1';
        -- else
          -- wait for 100 ns;
          -- valid   <= '0';
            -- i <= i + 1;
        -- end if;
        
        
        
        
        
        
        wait;
    end process;
  

  cmp_gem : entity work.gem
  port map(
    clk_i         => clk,
    rst_n_i       => rst_n,
    
    enable_i      => enable,
    
    data_iv       => data_v,
    valid_i       => valid,
    
    offset_val_iv     => "00" & x"000",
    threshold_val_iv  => "00" & x"100",
    
    min_pw_iv       => x"08",
    max_pw_iv       => x"20",
    tail_samp_iv    => x"02",
    
    test_state_id_ov  => open,
    
    
    error_too_short_cnt_ov          => open,
    error_too_short_cnt_ack_i       => '0',
    error_too_long_cnt_ov           => open,
    error_too_long_cnt_ack_i        => '0',
    error_negative_value_cnt_ov     => open,
    error_negative_value_cnt_ack_i  => '0',
    error_hist_bin_over_cnt_ov      => open,
    error_hist_bin_over_cnt_ack_i   => '0',
    error_overlapping_cnt_ov        => open,
    error_overlapping_cnt_ack_i     => '0',
    
    rst_dpram_address_i   => '0',
    
    bin_dpram_value_ov    => open,
    bin_dpram_value_ack_i => '0'
  
  
  );






end Behavioral;
