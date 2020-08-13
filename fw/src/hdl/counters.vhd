library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counters is



	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		probe_in : IN STD_LOGIC_VECTOR(7 downto 0);
		clock : IN STD_LOGIC;
		clk_shifter : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		frequency : IN STD_LOGIC_VECTOR(7 downto 0);
		pulse_width : IN STD_LOGIC_VECTOR(7 downto 0);
		probe_out : OUT STD_LOGIC_VECTOR(7 downto 0);
		noise_out : OUT STD_LOGIC;
		pulse_out : OUT STD_LOGIC
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!

end counters;

architecture v1 of counters  is

signal counter, counter_pw : STD_LOGIC_VECTOR(7 downto 0);
signal shiftreg : STD_LOGIC_VECTOR(15 downto 0);
signal clk : STD_LOGIC;
signal clkenable,clk_pw_enable, shiftreg_in : STD_LOGIC;
begin  -- v1
-- purpose: counts down to zero and when at zero, then it generates clkenable pulse which is exactly 1 tick lock
-- type   : sequential
-- inputs : clk, reset

clk <= clock;



count: process (clk, reset)
-- counter stuff
begin  -- process count
if reset = '1' then                   -- asynchronous reset (active high)
	counter <= frequency;                 -- set the state to the divider val.
elsif clk'event and clk = '1' then    -- rising clock edge
	counter <= counter - '1';             -- decrease counts
	if counter = "00" then
		counter <= frequency;
		clkenable <= '1';
	else
		clkenable <= '0';
	end if;
end if;
end process count;



 process (clk, reset)
-- counter stuff
begin  -- process count

if clk'event and clk = '1' then    -- rising clock edge
	if clkenable = '1' then                   -- ynchronous reset (active high)
		counter_pw <= pulse_width;                 -- set the state to the divider val.
		clk_pw_enable <= '1';
	elsif clk_pw_enable = '1' then
		counter_pw <= counter_pw - '1';             -- decrease counts
		if counter_pw = "00" then
			clk_pw_enable <= '0';
		end if;
	end if;
end if;
end process;

pulse_out <= clk_pw_enable and probe_in(1);

probe_out <= x"34";


Process (clk_shifter)
    begin
    if clk_shifter'event and clk_shifter='1' then
       shiftreg(15 downto 0) <=  shiftreg(14 downto 0) & shiftreg_in;
    end if;
end process;

shiftreg_in <= not (shiftreg(0) xor shiftreg(1) xor shiftreg(15));

noise_out <= shiftreg_in and probe_in(0);
end v1;

