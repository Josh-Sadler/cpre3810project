--simple test bench for 32-1 mux: 
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32t1_n is
  generic(gCLK_HPER   : time := 50 ns;
          N           : integer := 32);
end tb_mux32t1_n;

architecture behavior of tb_mux32t1_n is

  
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component mux32t1_n is
    generic(N : integer := 32);
    port(i_S  : in  std_logic_vector(4 downto 0);
         i_D0 : in  std_logic_vector(N-1 downto 0);
         i_D1 : in  std_logic_vector(N-1 downto 0);
         i_D2 : in  std_logic_vector(N-1 downto 0);
         i_D3 : in  std_logic_vector(N-1 downto 0);
         i_D4 : in  std_logic_vector(N-1 downto 0);
         i_D5 : in  std_logic_vector(N-1 downto 0);
         i_D6 : in  std_logic_vector(N-1 downto 0);
         i_D7 : in  std_logic_vector(N-1 downto 0);
         i_D8 : in  std_logic_vector(N-1 downto 0);
         i_D9 : in  std_logic_vector(N-1 downto 0);
         i_D10: in  std_logic_vector(N-1 downto 0);
         i_D11: in  std_logic_vector(N-1 downto 0);
         i_D12: in  std_logic_vector(N-1 downto 0);
         i_D13: in  std_logic_vector(N-1 downto 0);
         i_D14: in  std_logic_vector(N-1 downto 0);
         i_D15: in  std_logic_vector(N-1 downto 0);
         i_D16: in  std_logic_vector(N-1 downto 0);
         i_D17: in  std_logic_vector(N-1 downto 0);
         i_D18: in  std_logic_vector(N-1 downto 0);
         i_D19: in  std_logic_vector(N-1 downto 0);
         i_D20: in  std_logic_vector(N-1 downto 0);
         i_D21: in  std_logic_vector(N-1 downto 0);
         i_D22: in  std_logic_vector(N-1 downto 0);
         i_D23: in  std_logic_vector(N-1 downto 0);
         i_D24: in  std_logic_vector(N-1 downto 0);
         i_D25: in  std_logic_vector(N-1 downto 0);
         i_D26: in  std_logic_vector(N-1 downto 0);
         i_D27: in  std_logic_vector(N-1 downto 0);
         i_D28: in  std_logic_vector(N-1 downto 0);
         i_D29: in  std_logic_vector(N-1 downto 0);
         i_D30: in  std_logic_vector(N-1 downto 0);
         i_D31: in  std_logic_vector(N-1 downto 0);
         o_O  : out std_logic_vector(N-1 downto 0));
  end component;

  -- signals to connect to mux
  signal s_CLK : std_logic;
  signal s_S   : std_logic_vector(4 downto 0);
  signal s_O   : std_logic_vector(N-1 downto 0);

  -- Data inputs
  signal s_D0,  s_D1,  s_D2,  s_D3 : std_logic_vector(N-1 downto 0);
  signal s_D4,  s_D5,  s_D6,  s_D7  : std_logic_vector(N-1 downto 0);
  signal s_D8,  s_D9,  s_D10, s_D11 : std_logic_vector(N-1 downto 0);
  signal s_D12, s_D13, s_D14, s_D15 : std_logic_vector(N-1 downto 0);
  signal s_D16, s_D17, s_D18, s_D19 : std_logic_vector(N-1 downto 0);
  signal s_D20, s_D21, s_D22, s_D23 : std_logic_vector(N-1 downto 0);
  signal s_D24, s_D25, s_D26, s_D27 : std_logic_vector(N-1 downto 0);
  signal s_D28, s_D29, s_D30, s_D31 : std_logic_vector(N-1 downto 0);

begin

  DUT: mux32t1_n
    generic map(N => N)
    port map(i_S   => s_S,
             i_D0  => s_D0,
             i_D1  => s_D1,
             i_D2  => s_D2,
             i_D3  => s_D3,
             i_D4  => s_D4,
             i_D5  => s_D5,
             i_D6  => s_D6,
             i_D7  => s_D7,
             i_D8  => s_D8,
             i_D9  => s_D9,
             i_D10 => s_D10,
             i_D11 => s_D11,
             i_D12 => s_D12,
             i_D13 => s_D13,
             i_D14 => s_D14,
             i_D15 => s_D15,
             i_D16 => s_D16,
             i_D17 => s_D17,
             i_D18 => s_D18,
             i_D19 => s_D19,
             i_D20 => s_D20,
             i_D21 => s_D21,
             i_D22 => s_D22,
             i_D23 => s_D23,
             i_D24 => s_D24,
             i_D25 => s_D25,
             i_D26 => s_D26,
             i_D27 => s_D27,
             i_D28 => s_D28,
             i_D29 => s_D29,
             i_D30 => s_D30,
             i_D31 => s_D31,
             o_O   => s_O);

  -- Clock generator 
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  
  P_TB: process
  begin
    -- Initialize inputs with distinct values (easy to see on waveform)
    s_D0  <= x"00000000";
    s_D1  <= x"11111111";
    s_D2  <= x"22222222";
    s_D3  <= x"33333333";
    s_D4  <= x"44444444";
    s_D5  <= x"55555555";
    s_D6  <= x"66666666";
    s_D7  <= x"77777777";
    s_D8  <= x"88888888";
    s_D9  <= x"99999999";
    s_D10 <= x"AAAAAAAA";
    s_D11 <= x"BBBBBBBB";
    s_D12 <= x"CCCCCCCC";
    s_D13 <= x"DDDDDDDD";
    s_D14 <= x"EEEEEEEE";
    s_D15 <= x"FFFFFFFF";

    s_D16 <= x"01234567";
    s_D17 <= x"89ABCDEF";
    s_D18 <= x"0F0F0F0F";
    s_D19 <= x"F0F0F0F0";
    s_D20 <= x"76543210";
    s_D21 <= x"FEDCBA98";
    s_D22 <= x"02468ACE";
    s_D23 <= x"13579BDF";
    s_D24 <= x"ABCDEFFF";
    s_D25 <= x"FEEDBEED";
    s_D26 <= x"FFFEDCBA";
    s_D27 <= x"00000000";
    s_D28 <= x"00000001";
    s_D29 <= x"00000010";
    s_D30 <= x"00000100";
    s_D31 <= x"00001000";

    -- random cases to show it works
    s_S <= "00000"; --D0
    wait for cCLK_PER;

    s_S <= "00001"; --D1
    wait for cCLK_PER;

    s_S <= "00101"; --D5
    wait for cCLK_PER;

    s_S <= "01111"; -- 15
    wait for cCLK_PER;

    s_S <= "10000"; --D16
    wait for cCLK_PER;

    s_S <= "11001"; --D25
    wait for cCLK_PER;

    s_S <= "11111"; --D31
    wait for cCLK_PER;

    -- changing input without changing mux select:
    s_S <= "11000";  -- D24
    wait for cCLK_PER;

    s_D24 <= x"AAAAAAAA";
    wait for cCLK_PER;

    wait;
  end process;

end behavior;
