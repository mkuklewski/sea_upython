library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library general_cores;
use general_cores.wishbone_pkg.all;

library work;
package agwb_DAC7311_wb_pkg is
  constant agwb_DAC7311_wb_addr_bits : integer := 2;
constant C_Control_REG_ADDR: unsigned := x"00000002";
type t_Control is record
  WRITE:std_logic_vector(0 downto 0);
  MODE:std_logic_vector(1 downto 0);
  VALUE:std_logic_vector(11 downto 0);
  clk_divider:unsigned(15 downto 0);
end record;

function stlv2t_Control(x : std_logic_vector) return t_Control;
function t_Control2stlv(x : t_Control) return std_logic_vector;
constant C_Status_REG_ADDR: unsigned := x"00000003";
subtype t_Status is std_logic_vector(0 downto 0);


end agwb_DAC7311_wb_pkg;

package body agwb_DAC7311_wb_pkg is
function stlv2t_Control(x : std_logic_vector) return t_Control is
variable res : t_Control;
begin
  res.WRITE := std_logic_vector(x(0 downto 0));
  res.MODE := std_logic_vector(x(2 downto 1));
  res.VALUE := std_logic_vector(x(14 downto 3));
  res.clk_divider := unsigned(x(30 downto 15));
  return res;
end stlv2t_Control;

function t_Control2stlv(x : t_Control) return std_logic_vector is
variable res : std_logic_vector(30 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.WRITE);
  res(2 downto 1) := std_logic_vector(x.MODE);
  res(14 downto 3) := std_logic_vector(x.VALUE);
  res(30 downto 15) := std_logic_vector(x.clk_divider);
  return res;
end t_Control2stlv;


end agwb_DAC7311_wb_pkg;
