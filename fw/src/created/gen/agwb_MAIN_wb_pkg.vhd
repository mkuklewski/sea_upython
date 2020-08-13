library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library general_cores;
use general_cores.wishbone_pkg.all;

library work;
package agwb_MAIN_wb_pkg is
  constant agwb_MAIN_wb_addr_bits : integer := 5;
constant C_CTRL_REG_ADDR: unsigned := x"00000002";
type t_CTRL is record
  rst_n:std_logic_vector(0 downto 0);
end record;

function stlv2t_CTRL(x : std_logic_vector) return t_CTRL;
function t_CTRL2stlv(x : t_CTRL) return std_logic_vector;
constant C_TEST_0_REG_ADDR: unsigned := x"00000003";
type t_TEST_0 is record
  ENABLE:std_logic_vector(0 downto 0);
  VALUE:std_logic_vector(7 downto 0);
end record;

function stlv2t_TEST_0(x : std_logic_vector) return t_TEST_0;
function t_TEST_02stlv(x : t_TEST_0) return std_logic_vector;
constant C_TEST_1_REG_ADDR: unsigned := x"00000004";
type t_TEST_1 is record
  PERIOD:std_logic_vector(15 downto 0);
  PULSE_WIDHT:std_logic_vector(15 downto 0);
end record;

function stlv2t_TEST_1(x : std_logic_vector) return t_TEST_1;
function t_TEST_12stlv(x : t_TEST_1) return std_logic_vector;


end agwb_MAIN_wb_pkg;

package body agwb_MAIN_wb_pkg is
function stlv2t_CTRL(x : std_logic_vector) return t_CTRL is
variable res : t_CTRL;
begin
  res.rst_n := std_logic_vector(x(0 downto 0));
  return res;
end stlv2t_CTRL;

function t_CTRL2stlv(x : t_CTRL) return std_logic_vector is
variable res : std_logic_vector(0 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.rst_n);
  return res;
end t_CTRL2stlv;

function stlv2t_TEST_0(x : std_logic_vector) return t_TEST_0 is
variable res : t_TEST_0;
begin
  res.ENABLE := std_logic_vector(x(0 downto 0));
  res.VALUE := std_logic_vector(x(8 downto 1));
  return res;
end stlv2t_TEST_0;

function t_TEST_02stlv(x : t_TEST_0) return std_logic_vector is
variable res : std_logic_vector(8 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.ENABLE);
  res(8 downto 1) := std_logic_vector(x.VALUE);
  return res;
end t_TEST_02stlv;

function stlv2t_TEST_1(x : std_logic_vector) return t_TEST_1 is
variable res : t_TEST_1;
begin
  res.PERIOD := std_logic_vector(x(15 downto 0));
  res.PULSE_WIDHT := std_logic_vector(x(31 downto 16));
  return res;
end stlv2t_TEST_1;

function t_TEST_12stlv(x : t_TEST_1) return std_logic_vector is
variable res : std_logic_vector(31 downto 0);
begin
  res := (others => '0');
  res(15 downto 0) := std_logic_vector(x.PERIOD);
  res(31 downto 16) := std_logic_vector(x.PULSE_WIDHT);
  return res;
end t_TEST_12stlv;


end agwb_MAIN_wb_pkg;
