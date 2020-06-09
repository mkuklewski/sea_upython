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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DAC7311 is
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
      
    write_i       : in std_logic;       
    mode_iv       : in std_logic_vector(1 downto 0);    -- PD1  PD0   OPERATING MODE
                                                        --   0    0   Normal Operation
                                                        --   0    1   Output 1 kΩ to GND
                                                        --   1    0   Output 100 kΩ to GND
                                                        --   1    1   High-Z
    data_iv       : in std_logic_vector(11 downto 0);
    clk_divider_iv  : in std_logic_vector(15 downto 0);
    done_o        : out std_logic;
    
    dac_data_o    : out std_logic;
    dac_clk_o     : out std_logic;
    dac_sync_n_o  : out std_logic
    
  );    
end DAC7311;

architecture rtl of DAC7311 is

  type regs_type is record
    clk_cnt       : unsigned(31 downto 0);
    bit_cnt       : unsigned(7 downto 0);
    mode          : std_logic_vector(1 downto 0);
    data          : std_logic_vector(11 downto 0);
    done          : std_logic;
    dac_data      : std_logic;
    dac_clk       : std_logic;
    dac_sync_n    : std_logic;
  end record;
  
  constant regs_reset: regs_type := (
    clk_cnt   => (others => '0'),
    bit_cnt   => (others => '0'),
    mode      => (others => '0'),
    data      => (others => '0'),
    done         => '1',
    dac_data     => '0',
    dac_clk      => '0',
    dac_sync_n   => '1'
  );

  signal r      : regs_type := regs_reset;
  signal rin    : regs_type;

begin

    --
    -- Combinatorial process
    --
    process (r, rst_n_i, write_i, mode_iv, data_iv)  is
      variable v  : regs_type;
    begin
      v := r;
      
      
      v.dac_sync_n := '1';
      
      if ((write_i = '1') and (r.done = '1')) then
        v.done := '0';
        v.dac_clk := '0';
        v.clk_cnt := (others => '0');
        v.bit_cnt := (others => '0');
        v.mode  := mode_iv;
        v.data  := data_iv;
      end if;
      
      if (r.done = '0') then
        v.dac_sync_n := '0';
      
        v.clk_cnt := r.clk_cnt + 1;
        if (r.clk_cnt >= unsigned(clk_divider_iv)) then
          v.dac_clk := not r.dac_clk;
          v.clk_cnt := (others => '0');
          v.bit_cnt := r.bit_cnt + 1;
        end if;
        
        if (r.bit_cnt = 1) then
          v.dac_data := r.mode(1);
        elsif (r.bit_cnt = 3) then
          v.dac_data := r.mode(0);
        elsif (r.bit_cnt = 5) then
          v.dac_data := r.data(11);
        elsif (r.bit_cnt = 7) then
          v.dac_data := r.data(10);
        elsif (r.bit_cnt = 9) then
          v.dac_data := r.data(9);
        elsif (r.bit_cnt = 11) then
          v.dac_data := r.data(8);
        elsif (r.bit_cnt = 13) then
          v.dac_data := r.data(7);
        elsif (r.bit_cnt = 15) then
          v.dac_data := r.data(6);
        elsif (r.bit_cnt = 17) then
          v.dac_data := r.data(5);
        elsif (r.bit_cnt = 19) then
          v.dac_data := r.data(4);
        elsif (r.bit_cnt = 21) then
          v.dac_data := r.data(3);
        elsif (r.bit_cnt = 23) then
          v.dac_data := r.data(2);
        elsif (r.bit_cnt = 25) then
          v.dac_data := r.data(1);
        elsif (r.bit_cnt = 27) then
          v.dac_data := r.data(0);
        elsif (r.bit_cnt = 29) then
          v.dac_data := '0';
        elsif (r.bit_cnt = 31) then
          v.dac_data := '0';
        elsif (r.bit_cnt >= 33) then
          v.done := '1';
        end if;
      
      end if;
      
      
      --
      -- Drive output signals.
      --
      done_o <= r.done;
      
      dac_data_o   <= r.dac_data;
      dac_clk_o    <= r.dac_clk;
      dac_sync_n_o <= r.dac_sync_n;

      --
      -- Reset.
      --
      if rst_n_i = '0' then
          v   := regs_reset;
      end if;


      --
      -- Update registers.
      --
      rin <= v;
    end process;
    
    
    --
    -- Synchronous process: update registers.
    --
    process (clk_i) is
    begin
        if rising_edge(clk_i) then
            r <= rin;
        end if;
    end process;
    

end rtl;
