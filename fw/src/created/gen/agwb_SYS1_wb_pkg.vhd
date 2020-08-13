library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library general_cores;
use general_cores.wishbone_pkg.all;

library work;
package agwb_SYS1_wb_pkg is
  constant agwb_SYS1_wb_addr_bits : integer := 4;
constant C_CTRL_REG_ADDR: unsigned := x"00000002";
type t_CTRL is record
  START:std_logic_vector(0 downto 0);
  STOP:std_logic_vector(0 downto 0);
end record;

function stlv2t_CTRL(x : std_logic_vector) return t_CTRL;
function t_CTRL2stlv(x : t_CTRL) return std_logic_vector;
constant C_STATUS_REG_ADDR: unsigned := x"00000003";
subtype t_STATUS is std_logic_vector(31 downto 0);
constant C_ENABLEs_REG_ADDR: unsigned := x"00000004";
subtype t_ENABLEs is std_logic_vector(31 downto 0);
type t_ENABLEs_array is array(0 to 9) of t_ENABLEs;


end agwb_SYS1_wb_pkg;

package body agwb_SYS1_wb_pkg is
function stlv2t_CTRL(x : std_logic_vector) return t_CTRL is
variable res : t_CTRL;
begin
  res.START := std_logic_vector(x(0 downto 0));
  res.STOP := std_logic_vector(x(1 downto 1));
  return res;
end stlv2t_CTRL;

function t_CTRL2stlv(x : t_CTRL) return std_logic_vector is
variable res : std_logic_vector(1 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.START);
  res(1 downto 1) := std_logic_vector(x.STOP);
  return res;
end t_CTRL2stlv;


end agwb_SYS1_wb_pkg;
