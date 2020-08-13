----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2020 16:52:20
-- Design Name: 
-- Module Name: ADC1173 - rtl
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

entity ADC1173 is
  -- generic (
    -- g_system_clock    : integer := 100000000;
    -- g_sampling_rate   : integer :=  15000000   -- from 1 MHz to 20 MHz - best 15 MHz
  
  
  -- );
  port (
    clk_i       : in std_logic;
    rst_n_i     : in std_logic;
    
    enable_i    : in std_logic;
    clk_divider_iv  : in std_logic_vector(15 downto 0);
    
    adc_en_o      : out std_logic;
    adc_clk_o     : out std_logic;
    adc_data_iv   : in std_logic_vector(7 downto 0);
   
    data_ov     : out std_logic_vector(7 downto 0);
    valid_o     : out std_logic
  
  );
end ADC1173;

architecture rtl of ADC1173 is

  type regs_type is record
    clk_cnt   : unsigned(7 downto 0);
    -- sync_data_reg_0 : std_logic_vector(7 downto 0);
    -- sync_data_reg_1 : std_logic_vector(7 downto 0);
    adc_value : std_logic_vector(7 downto 0);
    valid     : std_logic;
    adc_en    : std_logic;
    adc_clk   : std_logic;
    adc_clk_reg   : std_logic;
  end record;
  
  constant regs_reset: regs_type := (
    clk_cnt   => (others => '0'),
    adc_value => (others => '0'),
    valid     => '0',
    adc_en    => '1',
    adc_clk   => '0',
    adc_clk_reg   => '0'
  );

  signal r      : regs_type := regs_reset;
  signal rin    : regs_type;
    

begin

    --
    -- Combinatorial process
    --
    process (r, rst_n_i, enable_i, adc_data_iv, clk_divider_iv)  is
      variable v:             regs_type;
    begin
      v := r;
      
      v.valid := '0';
      
      
      if (enable_i = '0') then
        v.adc_en := '1';
        v.adc_clk := '0';
      else
        v.adc_en := '0';
        v.clk_cnt := r.clk_cnt + 1;
        if (r.clk_cnt >= (unsigned(clk_divider_iv)) - 1) then
          v.adc_clk := not r.adc_clk;
        -- elsif (r.clk_cnt >= ((g_system_clock/g_sampling_rate)/2)) and (r.clk_cnt < (g_system_clock/g_sampling_rate)) then
          -- v.adc_clk := '1';
        -- else 
          v.clk_cnt := (others => '0');
        end if;
      end if;
      
      v.adc_clk_reg := r.adc_clk;
      
      if (r.adc_clk_reg = '1') and (r.adc_clk = '0') then
        v.adc_value := adc_data_iv;
        v.valid     := '1';      
      end if;
      
     
      --
      -- Drive output signals.
      --
      
      valid_o <= r.valid;
      data_ov <= r.adc_value;
      
      adc_en_o  <= r.adc_en;
      adc_clk_o <= r.adc_clk;

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

