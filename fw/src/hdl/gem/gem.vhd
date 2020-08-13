----------------------------------------------------------------------------------
-- Creator: Michal Kuklewski (michael.kuklewski@gmail.com)
-- Create Date: 15.06.2020 
-- 
----------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity gem is
  port (
    clk_i         : in std_logic;
    rst_n_i       : in std_logic;
    
    enable_i      : in std_logic;
    
    data_iv       : in std_logic_vector(7 downto 0);
    valid_i       : in std_logic;
    
    offset_val_iv    : in std_logic_vector(13 downto 0);
    threshold_val_iv : in std_logic_vector(13 downto 0);
    
    min_pw_iv       : in std_logic_vector(7 downto 0);
    max_pw_iv       : in std_logic_vector(7 downto 0);
    tail_samp_iv    : in std_logic_vector(7 downto 0);
    
    offset_readout_ov    : out std_logic_vector(14 downto 0);
    
    test_state_id_ov  : out std_logic_vector(2 downto 0);
    
    
    error_too_short_cnt_ov          : out std_logic_vector(15 downto 0);
    error_too_short_cnt_ack_i       : in  std_logic;
    error_too_long_cnt_ov           : out std_logic_vector(15 downto 0);
    error_too_long_cnt_ack_i        : in  std_logic;
    error_negative_value_cnt_ov     : out std_logic_vector(15 downto 0);
    error_negative_value_cnt_ack_i  : in  std_logic;
    error_hist_bin_over_cnt_ov      : out std_logic_vector(15 downto 0);
    error_hist_bin_over_cnt_ack_i   : in  std_logic;
    error_overlapping_cnt_ov        : out std_logic_vector(15 downto 0);
    error_overlapping_cnt_ack_i     : in  std_logic;
    
    rst_dpram_address_i   : in  std_logic;
    
    bin_dpram_value_ov    : out std_logic_vector(31 downto 0);
    bin_dpram_value_ack_i : in  std_logic
    
    
  );    
end gem;

architecture rtl of gem is

  type type_substract_data_v is array (7 downto 0) of signed(14 downto 0);
  type type_offset_val_v is array (7 downto 0) of signed(13 downto 0);
  
  type type_fsm is (idle, accumulate, tail);


  type regs_type is record
    adc_data_v        : signed(13 downto 0);
    substract_data_v  : type_substract_data_v;
    offset_val_v      : type_offset_val_v;
    valid_v           : std_logic_vector(7 downto 0);
    
    offset_readout_v           : std_logic_vector(14 downto 0);
    
    accumulator       : signed(21 downto 0);
    error_too_short_cnt        : unsigned(15 downto 0);
    error_too_long_cnt         : unsigned(15 downto 0);
    error_negative_value_cnt   : unsigned(15 downto 0);
    error_hist_bin_over_cnt    : unsigned(15 downto 0);
    error_overlapping_cnt      : unsigned(15 downto 0);
    
    
  
    acc_en      : std_logic;
    save_val      : std_logic;
    
    wea      : std_logic;
    addra    : std_logic_vector(7 downto 0);
    dina     : std_logic_vector(31 downto 0);
    
    sample_cnt        : unsigned(31 downto 0);
    
    web      : std_logic;
    dinb    : std_logic_vector(31 downto 0);
    addrb    : std_logic_vector(7 downto 0);
    
    main_fsm : type_fsm;
  
  
  end record;
  
  constant regs_reset: regs_type := (
    adc_data_v        => (others => '0'),
    substract_data_v  => (others => (others => '0')),
    offset_val_v      => (others => (others => '0')),
    valid_v           => (others => '0'),
    
    accumulator       => (others => '0'),
    
    offset_readout_v      => (others => '0'),
    
    
    error_too_short_cnt         => (others => '0'),
    error_too_long_cnt          => (others => '0'),
    error_negative_value_cnt    => (others => '0'),
    error_hist_bin_over_cnt     => (others => '0'),
    error_overlapping_cnt       => (others => '0'),
    
    acc_en     => '0',
    save_val     => '0',
    
    wea     => '0',
    addra   => (others => '0'),
    dina    => (others => '0'),
    
    sample_cnt    => (others => '0'),
    
    web     => '0',
    dinb    => (others => '0'),
    addrb    => (others => '0'),
    
    
    
    main_fsm      => idle
    
    
  );

  signal r      : regs_type := regs_reset;
  signal rin    : regs_type;
  
  
  signal s_wea      : std_logic;
  signal s_addra    : std_logic_vector(7 downto 0);
  signal s_dina     : std_logic_vector(31 downto 0);
  signal s_douta    : std_logic_vector(31 downto 0);
  
  signal s_web      : std_logic := '0';
  signal s_addrb    : std_logic_vector(7 downto 0);
  signal s_dinb     : std_logic_vector(31 downto 0);
  signal s_doutb    : std_logic_vector(31 downto 0);
  
  
  attribute MARK_DEBUG : string;
  attribute MARK_DEBUG of r : signal is "TRUE";
  -- attribute MARK_DEBUG of s_wea : signal is "TRUE";
  -- attribute MARK_DEBUG of s_dina : signal is "TRUE";
  -- attribute MARK_DEBUG of s_douta : signal is "TRUE";
  attribute MARK_DEBUG of valid_i : signal is "TRUE";
  attribute MARK_DEBUG of data_iv : signal is "TRUE";
  attribute MARK_DEBUG of enable_i : signal is "TRUE";
  -- attribute MARK_DEBUG of offset_readout_ov : signal is "TRUE";
  -- attribute MARK_DEBUG of test_state_id_ov : signal is "TRUE";

    
begin

    --
    -- Combinatorial process
    --
    process (r, rst_n_i, enable_i, valid_i, data_iv, offset_val_iv, threshold_val_iv, tail_samp_iv, s_douta, 
            error_too_short_cnt_ack_i, error_too_long_cnt_ack_i, error_negative_value_cnt_ack_i, 
            error_hist_bin_over_cnt_ack_i, error_overlapping_cnt_ack_i, bin_dpram_value_ack_i,
            rst_dpram_address_i)  is
      variable v    : regs_type;
    begin
      v := r;
      
      v.wea := '0';
      v.web := '0';
      
      if (error_too_short_cnt_ack_i = '1') then
        v.error_too_short_cnt := (others => '0');
      end if;  
      
      if (error_too_long_cnt_ack_i = '1') then
        v.error_too_long_cnt := (others => '0');
      end if;  
      
      if (error_negative_value_cnt_ack_i = '1') then
        v.error_negative_value_cnt := (others => '0');
      end if;  
      
      if (error_hist_bin_over_cnt_ack_i = '1') then
        v.error_hist_bin_over_cnt := (others => '0');
      end if;  
      
      if (error_overlapping_cnt_ack_i = '1') then
        v.error_overlapping_cnt := (others => '0');
      end if;  
      
      
      if (valid_i = '1') and (enable_i = '1') then
        v.adc_data_v := signed('0' & data_iv & "00000");  -- Size of input vector can be changed here
        
        v.substract_data_v(0) := resize(v.adc_data_v - signed(offset_val_iv), 15);
        v.substract_data_v(7 downto 1) := r.substract_data_v(6 downto 0);
        
        v.offset_val_v(0) := signed(offset_val_iv);
        v.offset_val_v(7 downto 1) := r.offset_val_v(6 downto 0);
        
      
        v.valid_v(0) := '1';
        v.valid_v(7 downto 1) := r.valid_v(6 downto 0);
        
      end if;
      
      
      if (r.acc_en = '1') then
        if (valid_i = '1') and (enable_i = '1') then
          v.accumulator := r.accumulator + r.substract_data_v(7);
        end if;
      else
        v.accumulator := (others => '0');
      end if;
      
      
      
      
      case r.main_fsm is
      
        when idle =>
          test_state_id_ov <= std_logic_vector(to_unsigned(0,3));
          
          v.sample_cnt := (others => '0');
          
          v.acc_en := '0';
      
          if (r.substract_data_v(0) > signed(threshold_val_iv)) and (r.valid_v(7) = '1') then
            
            v.main_fsm := accumulate;
            v.acc_en := '1';
            
            --latch ADC - Offset, after delay 
            v.offset_readout_v := std_logic_vector(r.substract_data_v(7));
            
            
          
          end if;
          
        when accumulate =>  
          test_state_id_ov <= std_logic_vector(to_unsigned(1,3));
          
          v.acc_en := '1';
          
          if (valid_i = '1') then
            v.sample_cnt := r.sample_cnt + 1;
          end if;
          
          if (r.sample_cnt >= unsigned(min_pw_iv)) then
          
            if (r.sample_cnt <= unsigned(max_pw_iv)) then
              
              if (r.substract_data_v(0) < signed(threshold_val_iv)) then
                if (unsigned(tail_samp_iv) > 0) then
                  v.main_fsm := tail;
                  v.sample_cnt := (others => '0');
                  
                  
                  
                else
                
                
                  if (r.accumulator >= 0) then 
                    v.addra     := std_logic_vector(unsigned(r.accumulator(r.accumulator'left downto r.accumulator'left - 7)));
                    v.save_val  := '1';
                  else 
                    if (error_negative_value_cnt_ack_i = '1') then
                      v.error_negative_value_cnt := to_unsigned(1,16);
                    else 
                      v.error_negative_value_cnt := r.error_negative_value_cnt + 1;
                    end if;  
                  end if;
                
                
                  -- ok value, save it
                  v.main_fsm := idle;
                end if;
              end if;
            else
            
              v.acc_en := '0';
              if (error_too_long_cnt_ack_i = '1') then
                v.error_too_long_cnt := to_unsigned(1,16);
              else 
                v.error_too_long_cnt := r.error_too_long_cnt + 1;
              end if;  
              v.main_fsm := idle;
            -- make error
            end if;
          else
            if (r.substract_data_v(0) < signed(threshold_val_iv)) then
              v.main_fsm := idle;
              if (error_too_short_cnt_ack_i = '1') then
                v.error_too_short_cnt := to_unsigned(1,16);
              else 
                v.error_too_short_cnt := r.error_too_short_cnt + 1;
              end if;  
            end if;
            
          end if;
          
          
          
        when tail =>  
          test_state_id_ov <= std_logic_vector(to_unsigned(2,3));
        
          if (valid_i = '1') then
            v.sample_cnt := r.sample_cnt + 1;
          end if;
          
          v.acc_en := '1';
          
          if (r.sample_cnt >= unsigned(tail_samp_iv)) then
          
            if (r.accumulator >= 0) then 
              v.addra := std_logic_vector(unsigned(r.accumulator(r.accumulator'left downto r.accumulator'left - 7)));
              v.save_val  := '1';
              
              if (r.substract_data_v(0) > signed(threshold_val_iv)) then
                if (error_overlapping_cnt_ack_i = '1') then
                  v.error_overlapping_cnt := to_unsigned(1,16);
                else 
                  v.error_overlapping_cnt := r.error_overlapping_cnt + 1;
                end if;  
              end if;
              
              
            else 
              if (error_negative_value_cnt_ack_i = '1') then
                v.error_negative_value_cnt := to_unsigned(1,16);
              else 
                v.error_negative_value_cnt := r.error_negative_value_cnt + 1;
              end if;  
            end if;
          
          
          
            v.acc_en := '0';
            v.main_fsm := idle;
          
          end if;
        
      end case;
      
      
      if (r.save_val = '1') then
        test_state_id_ov <= std_logic_vector(to_unsigned(3,3)); --not really a state, but might be useful
        
        v.save_val  := '0';
        v.wea       := '1';
        if (r.addra = r.addrb) and (bin_dpram_value_ack_i = '1') then
          v.dina      := std_logic_vector(to_unsigned(1,32));
        else
          if (s_douta = x"FFFFFFFF") then
            if (error_hist_bin_over_cnt_ack_i = '1') then
              v.error_hist_bin_over_cnt := to_unsigned(1,16);
            else 
              v.error_hist_bin_over_cnt := r.error_hist_bin_over_cnt + 1;
            end if;  
        
          else
            v.dina      := std_logic_vector(unsigned(s_douta) + 1);
          end if;
        end if;
        -- check if currently being read
      end if;
      
      if (rst_dpram_address_i = '1') then
        v.addrb := (others => '0');
      elsif (bin_dpram_value_ack_i = '1') then
        v.web := '1';
        v.dinb  := (others => '0');
        v.addrb := std_logic_vector(unsigned(r.addrb) + 1);
      end if;
      
      
      
     
      --
      -- Drive output signals.
      --
      
      error_too_short_cnt_ov      <= std_logic_vector(r.error_too_short_cnt);
      error_too_long_cnt_ov       <= std_logic_vector(r.error_too_long_cnt);  
      error_negative_value_cnt_ov <= std_logic_vector(r.error_negative_value_cnt);
      error_hist_bin_over_cnt_ov  <= std_logic_vector(r.error_hist_bin_over_cnt);
      error_overlapping_cnt_ov    <= std_logic_vector(r.error_overlapping_cnt);
      
      s_wea   <= r.wea;
      s_addra <= r.addra;
      s_dina  <= r.dina;
      
      s_web   <= r.web;
      s_addrb <= r.addrb;
      s_dinb  <= r.dinb;
      
      offset_readout_ov <= r.offset_readout_v;

      --
      -- Reset.
      --
      if rst_n_i = '0' then
          v   := regs_reset;
      end if;


      --
      -- Update registers.
      --
      rin <= v;
    end process;
    
    
    --
    -- Synchronous process: update registers.
    --
    process (clk_i) is
    begin
        if rising_edge(clk_i) then
            r <= rin;
        end if;
    end process;
    
    
    
  cmp_blk_mem_gen_0 : entity work.blk_mem_gen_0
    PORT MAP (
      clka        => clk_i,
      wea(0)      => s_wea,
      addra       => s_addra,
      dina        => s_dina,
      douta       => s_douta, 
      clkb        => clk_i,
      web(0)      => s_web,
      addrb       => s_addrb,
      dinb        => s_dinb,
      doutb       => s_doutb
    );
    
    bin_dpram_value_ov <= s_doutb;


end rtl;