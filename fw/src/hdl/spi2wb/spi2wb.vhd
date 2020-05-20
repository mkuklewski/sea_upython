-------------------------------------------------------------------------------
-- Title      : spi2wb - simple bridge providing control of Wishbone bus
--              via SPI interface. You may use it e.g. to control WB
--              from a microcontroler with SPI interface
--              The project was created especially for the
--              Spartan Edge Accelerator board
-- Project    : 
-------------------------------------------------------------------------------
-- File       : spi2wb.vhd
-- Author     : Wojciech M. Zabolotny
-- License    : PUBLIC DOMAIN or Creative Commons CC0
-- Company    : 
-- Created    : 2020-05-20
-- Last update: 2020-05-20
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:
--
--
--   That code is significantly based on my JTAG bus controller
--   published in https://groups.google.com/d/msg/alt.sources/Rh5yEuF2YGE/p6UB0RdRS-AJ
--   thread on alt.sources Usenet group.
--
--  We assume that SPI works in 8-bit mode
--  The two MSB bits in the fifth byte encode the operation.
--  1,0 - Sending address for READ operation (immediately triggers READ on WB)
--  1,1 - Sending address for WRITE operation (next DATA transfer triggers the
--        WRITE operation)
--  0,1 - Sending data for WRITE operation
--  0,0 - Reading status and data after READ operation, reading status after
--        WRITE operation
--  The operation is triggered after those bits are transmitted.
--  That ensures that a few SCK pulses are generated (needed by the CDC block)
--  The WB controller operates in the WB clock domain, and the SPI
--  operates in the SPI clock domain.
--  The SPI clock is not continuous. That could create problems for
--  CDC blocks, which have been worked around by presence of a few "dummy"
--  bits after the command.
--
--  Similarly, when receiving responses, the status is transmitted in bits
--  4 and 3 of the first byte. Bits 7, 6 and 5 are always sent as '0'.
--  However during their transmission a few SCK pulses are generated, which
--  drive the receiving part of the CDC block.
--  Bit 4 informs, that the WB operation is finished.
--  Bit 3 is set if the operation was successful.
--
--  The address remains unchanged after the operation. That makes implementation
--  of RMW operations easy. You may do READ (which sets the address),
--  then calculate the new value and issue WRITE (address was already set).

-------------------------------------------------------------------------------
-- Copyright (c) 2020 Wojciech M. Zabolotny (wzab<at>ise.pw.edu.pl or
--  wzab01<at>gmail.com )
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-05-20  1.0      wzab      Created
-------------------------------------------------------------------------------
--
--  This program is PUBLIC DOMAIN or Creative Commons CC0 code
--  You can do with it whatever you want. However, NO WARRANTY of ANY KIND
--  is provided
--
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
library general_cores;
use general_cores.wishbone_pkg.all;
library work;

entity spi2wb is
  generic (
    addr_width : integer := 32;
    data_width : integer := 32);
  port (
    -- start for debug
    o_led          : out std_logic;
    -- SPI connection
    spi_miso       : out std_logic;
    spi_mosi       : in  std_logic;
    spi_sck        : in  std_logic;
    spi_cs         : in  std_logic;
    -- Wishbone bus connection
    master_clk_i   : in  std_logic;
    master_rst_n_i : in  std_logic;
    master_i       : in  t_wishbone_master_in;
    master_o       : out t_wishbone_master_out
    );
end spi2wb;

architecture syn of spi2wb is

  attribute ASYNC_REG : string;

  constant C_SHIFT_LEN : integer                                  := 40;
  signal shift_cnt     : integer range 0 to C_SHIFT_LEN-1;
  signal shift_out     : std_logic_vector(C_SHIFT_LEN-1 downto 0) := (others => '0');
  signal shift_in      : std_logic_vector(C_SHIFT_LEN-1 downto 0) := (others => '0');

  signal spi_miso_s                  : std_logic;
  signal s_done_sync, s_done_async   : std_logic := '0';
  attribute ASYNC_REG of s_done_sync : signal is "TRUE";

  signal s_start, s_start_sync        : std_logic := '0';
  attribute ASYNC_REG of s_start_sync : signal is "TRUE";

  signal s_address : std_logic_vector(addr_width-1 downto 0);
  signal s_din     : std_logic_vector(data_width-1 downto 0);
  signal s_data    : std_logic_vector(data_width-1 downto 0);

  function maximum(L, R : integer) return integer is
  begin
    if L > R then
      return L;
    else
      return R;
    end if;
  end;

  type T_MODE is (SM_READ, SM_WRITE);
  signal s_mode : T_MODE := SM_READ;

  type TWB_STATE is (SWB_IDLE, SWB_WAIT_ACK);
  signal wb_state : TWB_STATE := SWB_IDLE;

  signal wb_status : std_logic := '0';

begin

  o_led    <= s_start;
  spi_miso <= spi_miso_s when spi_cs = '0' else 'Z';
  pspi1 : process (spi_sck, spi_cs) is
    variable oper : std_logic_vector(1 downto 0);
  begin  -- process pspi1
    if spi_cs = '1' then                -- synchronous reset (active high)
      spi_miso_s  <= '0';
      shift_cnt <= 0;
    elsif spi_sck'event and spi_sck = '1' then  -- rising clock edge
      -- Synchronization of the s_done_sync signal
      s_done_sync <= s_done_async;
      -- Update the shift counter
      if shift_cnt < C_SHIFT_LEN-1 then
        shift_cnt <= shift_cnt + 1;
      end if;
      -- Shift in bit to the input shift register
      shift_in(C_SHIFT_LEN-1-shift_cnt) <= spi_mosi;
      if shift_cnt < 2 then
        spi_miso_s <= '0';
      elsif shift_cnt = 2 then
        -- After the 2nd bit, check and report status of WB
        if s_start /= s_done_sync then
          -- Operation still in progress
          spi_miso_s <= '0';
          shift_out  <= (others => '0');
        else
          shift_out                            <= (others => '0');
          -- Operation completed, read the data
          spi_miso_s                           <= '1';
          -- First byte of response is filled with status
          -- First two bits were 0s, now we sent '1'
          -- So wb_status must be on the next position:
          shift_out(C_SHIFT_LEN-1-shift_cnt-1) <= wb_status;
          -- The response in on the last bits (we write it shifted by one to
          -- compensate delay)
          shift_out(data_width downto 1)     <= s_din;
        end if;
      else
        -- If it is not the 2nd bit, simply output the right bit from shift_out
        spi_miso_s <= shift_out(C_SHIFT_LEN-1-shift_cnt);
      end if;
      if shift_cnt = C_SHIFT_LEN-5 then
        -- Now the command code is already sent, so we can transmit it
        -- to WB, there will be yet a few SPI_SCK pulses transmitted!
        oper := shift_in(7 downto 6);
        case oper is
          when "11" =>
            -- Write, we have to wait for data to be written
            -- So here we store the address, and set the mode to "WRITE"
            s_address <= shift_in(addr_width-1+8 downto 8);
            s_mode    <= SM_WRITE;
          when "10" =>
            -- Read, we have received the address to read from
            s_address <= shift_in(addr_width-1+8 downto 8);
            -- Start immediately the read operation
            s_start   <= not s_start;
            s_mode    <= SM_READ;
          when "01" =>
            -- Data for "WRITE"
            s_mode  <= SM_WRITE;        -- Added for RMW!
            s_data  <= shift_in(data_width-1+8 downto 8);
            s_start <= not s_start;
          when "00" =>
            -- Read the status and received data - no action needed
            null;
          when others => null;
        end case;
      end if;
    end if;
  end process pspi1;

  -- Here is the implementation of the WB controller with CDC
  wpm : process (master_clk_i) is
  begin  -- process wpm
    if master_clk_i'event and master_clk_i = '1' then  -- rising clock edge
      if master_rst_n_i = '0' then      -- synchronous reset (active low)
        master_o.cyc <= '0';
        master_o.stb <= '0';
        master_o.adr <= (others => '0');
        master_o.dat <= (others => '0');
        wb_state     <= SWB_IDLE;
        s_done_async <= '0';
        s_start_sync <= '0';
      else
        -- Synchronize the start signal
        s_start_sync <= s_start;
        -- Main state machine
        case wb_state is
          when SWB_IDLE =>
            if s_start_sync /= s_done_async then
              -- New operation is scheduled
              -- Check if it is read or write
              master_o.adr <= s_address;
              master_o.dat <= s_data;
              master_o.stb <= '1';
              master_o.cyc <= '1';
              master_o.sel <= (others => '1');
              if s_mode = SM_WRITE then
                master_o.we <= '1';
              else
                master_o.we <= '0';
              end if;
              wb_state <= SWB_WAIT_ACK;
            end if;
          when SWB_WAIT_ACK =>
            if master_i.ack = '1' then
              s_din        <= master_i.dat;
              wb_status    <= '1';
              s_done_async <= s_start_sync;
              master_o.stb <= '0';
              master_o.cyc <= '0';
              wb_state     <= SWB_IDLE;
            end if;
            if master_i.err = '1' then
              s_din        <= master_i.dat;
              wb_status    <= '0';
              s_done_async <= s_start_sync;
              master_o.stb <= '0';
              master_o.cyc <= '0';
              wb_state     <= SWB_IDLE;
            end if;
          when others => null;
        end case;

      end if;
    end if;
  end process wpm;


end syn;
