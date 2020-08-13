library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library general_cores;
use general_cores.wishbone_pkg.all;

library work;
package agwb_GEM_wb_pkg is
  constant agwb_GEM_wb_addr_bits : integer := 4;
constant C_CTRL_0_REG_ADDR: unsigned := x"00000002";
type t_CTRL_0 is record
  ENABLE:std_logic_vector(0 downto 0);
  OFFSET:signed(13 downto 0);
  THRESHOLD:signed(13 downto 0);
end record;

function stlv2t_CTRL_0(x : std_logic_vector) return t_CTRL_0;
function t_CTRL_02stlv(x : t_CTRL_0) return std_logic_vector;
constant C_CTRL_1_REG_ADDR: unsigned := x"00000003";
type t_CTRL_1 is record
  MIN_PW:std_logic_vector(7 downto 0);
  MAX_PW:std_logic_vector(7 downto 0);
  TAIL:std_logic_vector(7 downto 0);
end record;

function stlv2t_CTRL_1(x : std_logic_vector) return t_CTRL_1;
function t_CTRL_12stlv(x : t_CTRL_1) return std_logic_vector;
constant C_Error_too_short_cnt_REG_ADDR: unsigned := x"00000004";
subtype t_Error_too_short_cnt is std_logic_vector(15 downto 0);
constant C_Error_too_long_cnt_REG_ADDR: unsigned := x"00000005";
subtype t_Error_too_long_cnt is std_logic_vector(15 downto 0);
constant C_Error_negative_value_cnt_REG_ADDR: unsigned := x"00000006";
subtype t_Error_negative_value_cnt is std_logic_vector(15 downto 0);
constant C_Error_hist_bin_over_cnt_REG_ADDR: unsigned := x"00000007";
subtype t_Error_hist_bin_over_cnt is std_logic_vector(15 downto 0);
constant C_Error_overlapping_cnt_REG_ADDR: unsigned := x"00000008";
subtype t_Error_overlapping_cnt is std_logic_vector(15 downto 0);
constant C_CTRL_2_REG_ADDR: unsigned := x"00000009";
type t_CTRL_2 is record
  RESET_DPRAM_ADDRESS:std_logic_vector(0 downto 0);
end record;

function stlv2t_CTRL_2(x : std_logic_vector) return t_CTRL_2;
function t_CTRL_22stlv(x : t_CTRL_2) return std_logic_vector;
constant C_BIN_VALUE_REG_ADDR: unsigned := x"0000000a";
subtype t_BIN_VALUE is std_logic_vector(31 downto 0);
constant C_OFFSET_READOUT_REG_ADDR: unsigned := x"0000000b";
subtype t_OFFSET_READOUT is signed(14 downto 0);
constant C_FSM_STATE_REG_ADDR: unsigned := x"0000000c";
subtype t_FSM_STATE is std_logic_vector(2 downto 0);


end agwb_GEM_wb_pkg;

package body agwb_GEM_wb_pkg is
function stlv2t_CTRL_0(x : std_logic_vector) return t_CTRL_0 is
variable res : t_CTRL_0;
begin
  res.ENABLE := std_logic_vector(x(0 downto 0));
  res.OFFSET := signed(x(14 downto 1));
  res.THRESHOLD := signed(x(28 downto 15));
  return res;
end stlv2t_CTRL_0;

function t_CTRL_02stlv(x : t_CTRL_0) return std_logic_vector is
variable res : std_logic_vector(28 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.ENABLE);
  res(14 downto 1) := std_logic_vector(x.OFFSET);
  res(28 downto 15) := std_logic_vector(x.THRESHOLD);
  return res;
end t_CTRL_02stlv;

function stlv2t_CTRL_1(x : std_logic_vector) return t_CTRL_1 is
variable res : t_CTRL_1;
begin
  res.MIN_PW := std_logic_vector(x(7 downto 0));
  res.MAX_PW := std_logic_vector(x(15 downto 8));
  res.TAIL := std_logic_vector(x(23 downto 16));
  return res;
end stlv2t_CTRL_1;

function t_CTRL_12stlv(x : t_CTRL_1) return std_logic_vector is
variable res : std_logic_vector(23 downto 0);
begin
  res := (others => '0');
  res(7 downto 0) := std_logic_vector(x.MIN_PW);
  res(15 downto 8) := std_logic_vector(x.MAX_PW);
  res(23 downto 16) := std_logic_vector(x.TAIL);
  return res;
end t_CTRL_12stlv;

function stlv2t_CTRL_2(x : std_logic_vector) return t_CTRL_2 is
variable res : t_CTRL_2;
begin
  res.RESET_DPRAM_ADDRESS := std_logic_vector(x(0 downto 0));
  return res;
end stlv2t_CTRL_2;

function t_CTRL_22stlv(x : t_CTRL_2) return std_logic_vector is
variable res : std_logic_vector(0 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.RESET_DPRAM_ADDRESS);
  return res;
end t_CTRL_22stlv;


end agwb_GEM_wb_pkg;
