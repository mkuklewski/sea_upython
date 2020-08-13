library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library general_cores;
use general_cores.wishbone_pkg.all;

library work;
package agwb_ADC1173_wb_pkg is
  constant agwb_ADC1173_wb_addr_bits : integer := 2;
constant C_Control_REG_ADDR: unsigned := x"00000002";
type t_Control is record
  ENABLE:std_logic_vector(0 downto 0);
  clk_divider:unsigned(15 downto 0);
end record;

function stlv2t_Control(x : std_logic_vector) return t_Control;
function t_Control2stlv(x : t_Control) return std_logic_vector;
constant C_ADC_Val_REG_ADDR: unsigned := x"00000003";
subtype t_ADC_Val is std_logic_vector(7 downto 0);


end agwb_ADC1173_wb_pkg;

package body agwb_ADC1173_wb_pkg is
function stlv2t_Control(x : std_logic_vector) return t_Control is
variable res : t_Control;
begin
  res.ENABLE := std_logic_vector(x(0 downto 0));
  res.clk_divider := unsigned(x(16 downto 1));
  return res;
end stlv2t_Control;

function t_Control2stlv(x : t_Control) return std_logic_vector is
variable res : std_logic_vector(16 downto 0);
begin
  res := (others => '0');
  res(0 downto 0) := std_logic_vector(x.ENABLE);
  res(16 downto 1) := std_logic_vector(x.clk_divider);
  return res;
end t_Control2stlv;


end agwb_ADC1173_wb_pkg;
