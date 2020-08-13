  --- This code is automatically generated by the addrgen_wb.py tool
  --- Please don't edit it manaully, unless you really have to do it.

  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  library general_cores;
  use general_cores.wishbone_pkg.all;
  library work;
  use work.agwb_MAIN_wb_pkg.all;

  entity agwb_MAIN_wb is
    port (
      slave_i : in t_wishbone_slave_in;
      slave_o : out t_wishbone_slave_out;
      GEM_wb_m_o : out t_wishbone_master_out_array(0 to 0);
      GEM_wb_m_i : in t_wishbone_master_in_array(0 to 0);
      DAC7311_wb_m_o : out t_wishbone_master_out_array(0 to 0);
      DAC7311_wb_m_i : in t_wishbone_master_in_array(0 to 0);
      ADC1173_wb_m_o : out t_wishbone_master_out_array(0 to 0);
      ADC1173_wb_m_i : in t_wishbone_master_in_array(0 to 0);

      CTRL_o : out  t_CTRL;
      TEST_0_o : out  t_TEST_0;
      TEST_1_o : out  t_TEST_1;

      rst_n_i : in std_logic;
      clk_sys_i : in std_logic
      );

  end agwb_MAIN_wb;

  architecture gener of agwb_MAIN_wb is
      signal int_CTRL_o : t_CTRL := stlv2t_CTRL(std_logic_vector(to_unsigned(1,1))); -- Hex value: 0x1
    signal int_TEST_0_o : t_TEST_0;
    signal int_TEST_1_o : t_TEST_1;

    -- Internal WB declaration
    signal int_regs_wb_m_o : t_wishbone_master_out;
    signal int_regs_wb_m_i : t_wishbone_master_in;
    signal int_addr : std_logic_vector(3-1 downto 0);
    signal wb_up_o : t_wishbone_slave_out_array(0 to 0);
    signal wb_up_i : t_wishbone_slave_in_array(0 to 0);
    signal wb_m_o : t_wishbone_master_out_array(0 to 4-1);
    signal wb_m_i : t_wishbone_master_in_array(0 to 4-1);

    -- Constants
    constant c_address : t_wishbone_address_array(0 to 4-1) := (0=>"00000000000000000000000000000000",1=>"00000000000000000000000000010000",2=>"00000000000000000000000000011000",3=>"00000000000000000000000000011100");
    constant c_mask : t_wishbone_address_array(0 to 4-1) := (0=>"00000000000000000000000000010000",1=>"00000000000000000000000000011000",2=>"00000000000000000000000000011100",3=>"00000000000000000000000000011100");

  begin
    wb_up_i(0) <= slave_i;
    slave_o <= wb_up_o(0);
    int_addr <= int_regs_wb_m_o.adr(3-1 downto 0);

  -- Main crossbar
    xwb_crossbar_1: entity general_cores.xwb_crossbar
    generic map (
       g_num_masters => 1,
       g_num_slaves  => 4,
       g_registered  => false,
       g_address     => c_address,
       g_mask        => c_mask)
    port map (
       clk_sys_i => clk_sys_i,
       rst_n_i   => rst_n_i,
        slave_i   => wb_up_i,
        slave_o   => wb_up_o,
       master_i  => wb_m_i,
       master_o  => wb_m_o,
      sdb_sel_o => open);

  -- Process for register access
    process(clk_sys_i)
    begin
      if rising_edge(clk_sys_i) then
        if rst_n_i = '0' then
          -- Reset of the core
          int_regs_wb_m_i <= c_DUMMY_WB_MASTER_IN;
            int_CTRL_o <= stlv2t_CTRL(std_logic_vector(to_unsigned(1,1))); -- Hex value: 0x1

        else
          -- Normal operation
          int_regs_wb_m_i.rty <= '0';
          int_regs_wb_m_i.ack <= '0';
          int_regs_wb_m_i.err <= '0';

          if (int_regs_wb_m_o.cyc = '1') and (int_regs_wb_m_o.stb = '1') then
            int_regs_wb_m_i.err <= '1'; -- in case of missed address
            -- Access, now we handle consecutive registers
            case int_addr is
            when "010" => -- 0x2
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(0 downto 0) <= t_CTRL2stlv(int_CTRL_o);
               if int_regs_wb_m_o.we = '1' then
                 int_CTRL_o <= stlv2t_CTRL(int_regs_wb_m_o.dat(0 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "011" => -- 0x3
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(8 downto 0) <= t_TEST_02stlv(int_TEST_0_o);
               if int_regs_wb_m_o.we = '1' then
                 int_TEST_0_o <= stlv2t_TEST_0(int_regs_wb_m_o.dat(8 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "100" => -- 0x4
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(31 downto 0) <= t_TEST_12stlv(int_TEST_1_o);
               if int_regs_wb_m_o.we = '1' then
                 int_TEST_1_o <= stlv2t_TEST_1(int_regs_wb_m_o.dat(31 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';

            when "000" =>
               int_regs_wb_m_i.dat <= x"89bd20d0";
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "001" =>
               int_regs_wb_m_i.dat <= x"762a56fb";
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when others =>
               int_regs_wb_m_i.dat <= x"A5A5A5A5";
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            end case;
          end if;
        end if;
      end if;
    end process;
    CTRL_o <= int_CTRL_o;
    TEST_0_o <= int_TEST_0_o;
    TEST_1_o <= int_TEST_1_o;
    wb_m_i(0) <= GEM_wb_m_i(0);
    GEM_wb_m_o(0)  <= wb_m_o(0);
    wb_m_i(1) <= int_regs_wb_m_i;
    int_regs_wb_m_o  <= wb_m_o(1);
    wb_m_i(2) <= DAC7311_wb_m_i(0);
    DAC7311_wb_m_o(0)  <= wb_m_o(2);
    wb_m_i(3) <= ADC1173_wb_m_i(0);
    ADC1173_wb_m_o(0)  <= wb_m_o(3);

  end architecture;
