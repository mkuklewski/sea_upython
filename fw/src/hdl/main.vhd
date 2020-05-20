library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library general_cores;
use general_cores.wishbone_pkg.all;
library work;
use work.agwb_MAIN_wb_pkg.all;

entity main is

  port (
    --rst_n_i   : in  std_logic;
    clk_sys_i : in  std_logic;
    --clk_io_i  : in  std_logic;
    o_led     : out std_logic;
    -- SPI interface
    spi_miso  : out std_logic;
    spi_mosi  : in  std_logic;
    spi_sck   : in  std_logic;
    spi_cs    : in  std_logic
    );

end entity main;

architecture rtl of main is
  signal wb_s_in                                      : t_wishbone_slave_in;
  signal wb_s_out                                     : t_wishbone_slave_out;
  signal LINKS_wb_m_o                                 : t_wishbone_master_out_array(0 to 4);
  signal LINKS_wb_m_i                                 : t_wishbone_master_in_array(0 to 4);
  signal EXTERN_wb_m_o                                : t_wishbone_master_out_array(0 to 2);
  signal EXTERN_wb_m_i                                : t_wishbone_master_in_array(0 to 2);
  signal CDC_wb_m_o                                   : t_wishbone_master_out_array(0 to 2);
  signal CDC_wb_m_i                                   : t_wishbone_master_in_array(0 to 2);
  signal CTRL_o                                       : t_CTRL;
  signal rst_sys_0, rst_sys_n_i, rst_io_0, rst_io_n_i : std_logic;
  signal clk_io_i                                     : std_logic;
  signal rst_n_i                                      : std_logic                 := '0';
  signal rst_cnt                                      : integer range 0 to 100000 := 100000;

  attribute ASYNC_REG                                                 : string;
  attribute ASYNC_REG of rst_sys_0, rst_sys_n_i, rst_io_0, rst_io_n_i : signal is "TRUE";
begin  -- architecture rtl

  clk_io_i <= clk_sys_i;
  --o_led <= rst_n_i;

  -- generation of reset
  process (clk_sys_i) is
  begin  -- process
    if clk_sys_i'event and clk_sys_i = '1' then  -- rising clock edge
      if rst_cnt > 0 then
        rst_n_i <= '0';
        rst_cnt <= rst_cnt - 1;
      else
        rst_n_i <= '1';
      end if;
      rst_sys_0   <= rst_n_i;
      rst_sys_n_i <= rst_sys_0;
    end if;
  end process;

  process (clk_io_i) is
  begin  -- process
    if clk_io_i'event and clk_io_i = '1' then  -- rising clock edge
      rst_io_0   <= rst_n_i;
      rst_io_n_i <= rst_io_0;
    end if;
  end process;

  spi2wb_1 : entity work.spi2wb
    generic map (
      addr_width => 32,
      data_width => 32)
    port map (
      o_led          => o_led,
      spi_miso       => spi_miso,
      spi_mosi       => spi_mosi,
      spi_sck        => spi_sck,
      spi_cs         => spi_cs,
      master_clk_i   => clk_sys_i,
      master_rst_n_i => rst_sys_n_i,
      master_i       => wb_s_out,
      master_o       => wb_s_in);

  MAIN_wb_1 : entity work.agwb_MAIN_wb
    port map (
      slave_i       => wb_s_in,
      slave_o       => wb_s_out,
      LINKS_wb_m_o  => LINKS_wb_m_o,
      LINKS_wb_m_i  => LINKS_wb_m_i,
      EXTERN_wb_m_o => CDC_wb_m_o,
      EXTERN_wb_m_i => CDC_wb_m_i,
      CTRL_o        => CTRL_o,
      rst_n_i       => rst_sys_n_i,
      clk_sys_i     => clk_sys_i);

  gl0 : for i in 0 to 2 generate
    wb_cdc_1 : entity work.wb_cdc
      generic map (
        width => 32)
      port map (
        slave_clk_i    => clk_sys_i,
        slave_rst_n_i  => rst_sys_n_i,
        slave_i        => CDC_wb_m_o(i),
        slave_o        => CDC_wb_m_i(i),
        master_clk_i   => clk_io_i,
        master_rst_n_i => rst_io_n_i,
        master_i       => EXTERN_wb_m_i(i),
        master_o       => EXTERN_wb_m_o(i));

    ext_1 : entity work.exttest
      generic map (
        instance_number => 1,
        addr_size       => 10
        )
      port map (
        rst_n_i   => rst_io_n_i,
        clk_sys_i => clk_io_i,
        wb_s_in   => EXTERN_wb_m_o(i),
        wb_s_out  => EXTERN_wb_m_i(i));

  end generate gl0;

  gl1 : for i in 0 to 4 generate

    sys1_1 : entity work.sys1
      port map (
        rst_n_i   => rst_sys_n_i,
        clk_sys_i => clk_sys_i,
        wb_s_in   => LINKS_wb_m_o(i),
        wb_s_out  => LINKS_wb_m_i(i));

  end generate gl1;

end architecture rtl;
