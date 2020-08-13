  --- This code is automatically generated by the addrgen_wb.py tool
  --- Please don't edit it manaully, unless you really have to do it.

  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  library general_cores;
  use general_cores.wishbone_pkg.all;
  library work;
  use work.agwb_GEM_wb_pkg.all;

  entity agwb_GEM_wb is
    port (
      slave_i : in t_wishbone_slave_in;
      slave_o : out t_wishbone_slave_out;

      CTRL_0_o : out  t_CTRL_0;
      CTRL_1_o : out  t_CTRL_1;
      Error_too_short_cnt_i : in  t_Error_too_short_cnt;
      Error_too_short_cnt_i_ack : out std_logic;
      Error_too_long_cnt_i : in  t_Error_too_long_cnt;
      Error_too_long_cnt_i_ack : out std_logic;
      Error_negative_value_cnt_i : in  t_Error_negative_value_cnt;
      Error_negative_value_cnt_i_ack : out std_logic;
      Error_hist_bin_over_cnt_i : in  t_Error_hist_bin_over_cnt;
      Error_hist_bin_over_cnt_i_ack : out std_logic;
      Error_overlapping_cnt_i : in  t_Error_overlapping_cnt;
      Error_overlapping_cnt_i_ack : out std_logic;
      CTRL_2_o : out  t_CTRL_2;
      BIN_VALUE_i : in  t_BIN_VALUE;
      BIN_VALUE_i_ack : out std_logic;
      OFFSET_READOUT_i : in  t_OFFSET_READOUT;
      OFFSET_READOUT_i_ack : out std_logic;
      FSM_STATE_i : in  t_FSM_STATE;
      FSM_STATE_i_ack : out std_logic;

      rst_n_i : in std_logic;
      clk_sys_i : in std_logic
      );

  end agwb_GEM_wb;

  architecture gener of agwb_GEM_wb is
      signal int_CTRL_0_o : t_CTRL_0 := stlv2t_CTRL_0(std_logic_vector(to_unsigned(0,29))); -- Hex value: 0x0
    signal int_CTRL_1_o : t_CTRL_1;
    signal int_CTRL_2_o : t_CTRL_2;

    -- Internal WB declaration
    signal int_regs_wb_m_o : t_wishbone_master_out;
    signal int_regs_wb_m_i : t_wishbone_master_in;
    signal int_addr : std_logic_vector(4-1 downto 0);
    signal wb_up_o : t_wishbone_slave_out_array(0 to 0);
    signal wb_up_i : t_wishbone_slave_in_array(0 to 0);
    signal wb_m_o : t_wishbone_master_out_array(0 to 1-1);
    signal wb_m_i : t_wishbone_master_in_array(0 to 1-1);

    -- Constants
    constant c_address : t_wishbone_address_array(0 to 1-1) := (0=>"00000000000000000000000000000000");
    constant c_mask : t_wishbone_address_array(0 to 1-1) := (0=>"00000000000000000000000000000000");

  begin
    wb_up_i(0) <= slave_i;
    slave_o <= wb_up_o(0);
    int_addr <= int_regs_wb_m_o.adr(4-1 downto 0);

  -- Main crossbar
    xwb_crossbar_1: entity general_cores.xwb_crossbar
    generic map (
       g_num_masters => 1,
       g_num_slaves  => 1,
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
            int_CTRL_0_o <= stlv2t_CTRL_0(std_logic_vector(to_unsigned(0,29))); -- Hex value: 0x0

        else
          -- Normal operation
          int_regs_wb_m_i.rty <= '0';
          int_regs_wb_m_i.ack <= '0';
          int_regs_wb_m_i.err <= '0';
          Error_too_short_cnt_i_ack <= '0';
          Error_too_long_cnt_i_ack <= '0';
          Error_negative_value_cnt_i_ack <= '0';
          Error_hist_bin_over_cnt_i_ack <= '0';
          Error_overlapping_cnt_i_ack <= '0';
          BIN_VALUE_i_ack <= '0';
          OFFSET_READOUT_i_ack <= '0';
          FSM_STATE_i_ack <= '0';

          if (int_regs_wb_m_o.cyc = '1') and (int_regs_wb_m_o.stb = '1') then
            int_regs_wb_m_i.err <= '1'; -- in case of missed address
            -- Access, now we handle consecutive registers
            case int_addr is
            when "0010" => -- 0x2
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(28 downto 0) <= t_CTRL_02stlv(int_CTRL_0_o);
               if int_regs_wb_m_o.we = '1' then
                 int_CTRL_0_o <= stlv2t_CTRL_0(int_regs_wb_m_o.dat(28 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0011" => -- 0x3
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(23 downto 0) <= t_CTRL_12stlv(int_CTRL_1_o);
               if int_regs_wb_m_o.we = '1' then
                 int_CTRL_1_o <= stlv2t_CTRL_1(int_regs_wb_m_o.dat(23 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0100" => -- 0x4
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(15 downto 0) <= std_logic_vector(Error_too_short_cnt_i);
               if int_regs_wb_m_i.ack = '0' then
                  Error_too_short_cnt_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0101" => -- 0x5
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(15 downto 0) <= std_logic_vector(Error_too_long_cnt_i);
               if int_regs_wb_m_i.ack = '0' then
                  Error_too_long_cnt_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0110" => -- 0x6
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(15 downto 0) <= std_logic_vector(Error_negative_value_cnt_i);
               if int_regs_wb_m_i.ack = '0' then
                  Error_negative_value_cnt_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0111" => -- 0x7
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(15 downto 0) <= std_logic_vector(Error_hist_bin_over_cnt_i);
               if int_regs_wb_m_i.ack = '0' then
                  Error_hist_bin_over_cnt_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "1000" => -- 0x8
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(15 downto 0) <= std_logic_vector(Error_overlapping_cnt_i);
               if int_regs_wb_m_i.ack = '0' then
                  Error_overlapping_cnt_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "1001" => -- 0x9
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(0 downto 0) <= t_CTRL_22stlv(int_CTRL_2_o);
               if int_regs_wb_m_o.we = '1' then
                 int_CTRL_2_o <= stlv2t_CTRL_2(int_regs_wb_m_o.dat(0 downto 0));
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "1010" => -- 0xa
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(31 downto 0) <= std_logic_vector(BIN_VALUE_i);
               if int_regs_wb_m_i.ack = '0' then
                  BIN_VALUE_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "1011" => -- 0xb
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(14 downto 0) <= std_logic_vector(OFFSET_READOUT_i);
               if int_regs_wb_m_i.ack = '0' then
                  OFFSET_READOUT_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "1100" => -- 0xc
               int_regs_wb_m_i.dat <= (others => '0');
               int_regs_wb_m_i.dat(2 downto 0) <= std_logic_vector(FSM_STATE_i);
               if int_regs_wb_m_i.ack = '0' then
                  FSM_STATE_i_ack <= '1';
               end if;
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';

            when "0000" =>
               int_regs_wb_m_i.dat <= x"0ff7c43a";
               int_regs_wb_m_i.ack <= '1';
               int_regs_wb_m_i.err <= '0';
            when "0001" =>
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
    CTRL_0_o <= int_CTRL_0_o;
    CTRL_1_o <= int_CTRL_1_o;
    CTRL_2_o <= int_CTRL_2_o;
    wb_m_i(0) <= int_regs_wb_m_i;
    int_regs_wb_m_o  <= wb_m_o(0);

  end architecture;