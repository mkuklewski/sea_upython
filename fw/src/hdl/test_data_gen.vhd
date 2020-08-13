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

entity test_data_gen is
  generic (
    g_system_frequency  : integer := 100_000_000
  );
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
      
    enable_i        : in std_logic;
    period_iv       : in std_logic_vector(15 downto 0);
    pulse_width_iv  : in std_logic_vector(15 downto 0);
    value_iv        : in std_logic_vector(7 downto 0);
    
    test_data_ov  : out std_logic_vector(7 downto 0);
    test_valid_o  : out std_logic
      
      
    
  );    
end test_data_gen;

architecture rtl of test_data_gen is

  type regs_type is record
    clk_cnt       : unsigned(15 downto 0);
    sample_cnt       : unsigned(15 downto 0);
    pulse_cnt     : unsigned(15 downto 0);
    test_data     : std_logic_vector(7 downto 0);
    test_valid    : std_logic;
    
  end record;
  
  constant regs_reset: regs_type := (
    clk_cnt   => (others => '0'),
    sample_cnt   => (others => '0'),
    pulse_cnt => (others => '0'),
    test_data => (others => '0'),
    test_valid  => '0'
    
    
  );

  signal r      : regs_type := regs_reset;
  signal rin    : regs_type;

  
  -- attribute MARK_DEBUG : string;
  -- attribute MARK_DEBUG of r : signal is "TRUE";
  -- attribute MARK_DEBUG of enable_i : signal is "TRUE";
  -- attribute MARK_DEBUG of pulse_width_iv : signal is "TRUE";
  -- attribute MARK_DEBUG of value_iv : signal is "TRUE";
  -- attribute MARK_DEBUG of test_data_ov : signal is "TRUE";
  
begin

    --
    -- Combinatorial process
    --
    process (r, rst_n_i, enable_i, period_iv, pulse_width_iv, value_iv)  is
      variable v  : regs_type;
    begin
      v := r;
      
      v.test_valid  := '0';
      
      if (enable_i = '1') then
        if (r.clk_cnt = 0) then
          v.clk_cnt := unsigned(period_iv) - 1; -- probably -1
          -- v.pulse_en  := '1';
          v.pulse_cnt := unsigned(pulse_width_iv) - 1;
          
          
        else 
          v.clk_cnt := r.clk_cnt - 1;
        end if;
        
        -- Add below lines if there is need for the generator to work as ADC1173 IP Core output
        -- if r.sample_cnt = 0 then
          -- v.sample_cnt := to_unsigned(9,16);
          if r.pulse_cnt > 0 then
            v.test_data   := value_iv;
            v.test_valid  := '1';
            v.pulse_cnt := r.pulse_cnt - 1;
          else
            v.test_data   := x"00";
          
          end if;
        -- else
          -- v.sample_cnt := r.sample_cnt - 1;
        -- end if;
        
      
      
      
      
      
      
      end if;
      
      
      
      
      --
      -- Drive output signals.
      --
      test_data_ov  <= r.test_data;
      test_valid_o  <= r.test_valid;
      
      
      

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
