--Author: John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_regfile is
  generic(gCLK_HPER : time := 50 ns);
end tb_regfile;

architecture behavior of tb_regfile is

  constant cCLK_PER : time := gCLK_HPER * 2;

  component regfile is
    port(i_CLK   : in  std_logic;
      i_RST   : in  std_logic;
      i_WE    : in  std_logic;
      i_WA    : in  std_logic_vector(5-1 downto 0);
      i_RA1   : in  std_logic_vector(5-1 downto 0);
      i_RA2   : in  std_logic_vector(5-1 downto 0);
      i_WD    : in  std_logic_vector(32-1 downto 0);
      o_RD1   : out std_logic_vector(32-1 downto 0);
      o_RD2   : out std_logic_vector(32-1 downto 0));
  end component;

  signal s_CLK, s_RST, s_WE : std_logic;
  signal s_WA, s_RA1, s_RA2 : std_logic_vector(5-1 downto 0);
  signal s_WD : std_logic_vector(32-1 downto 0);
  signal s_RD1, s_RD2 : std_logic_vector(32-1 downto 0);

begin

  DUT: regfile
    port map(i_CLK => s_CLK,
     i_RST => s_RST,
     i_WE  => s_WE,
     i_WA  => s_WA,
     i_RA1 => s_RA1,
     i_RA2 => s_RA2,
     i_WD  => s_WD,
     o_RD1 => s_RD1,
     o_RD2 => s_RD2);

  -- Clock generator
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- Test process
  P_TB: process
  begin
    -- Reset (all regs should go to 0; x0 always 0)
    s_RST <= '1';
    s_WE  <= '0';
    s_WA  <= "00000";
    s_RA1 <= "00000";
    s_RA2 <= "00000";
    s_WD  <= x"00000000";
    wait for cCLK_PER;

    s_RST <= '0';
    wait for cCLK_PER;


    -- Write x1 = 0x00000001
    s_WE  <= '1';
    s_WA  <= "00001";
    s_WD  <= x"00000001";
    wait for cCLK_PER;

    -- Write x2 = 0x00000020
    s_WA  <= "00010";
    s_WD  <= x"00000020";
    wait for cCLK_PER;


    -- Try to write x0=0xFFFFFFFF (should be ignored since it's the zero register)
    s_WA  <= "00000";
    s_WD  <= x"FFFFFFFF";
    wait for cCLK_PER;

    -- Stop writing
    s_WE <= '0';
    wait for cCLK_PER;


    -- Read back: rs1=x0, rs2=x1
    s_RA1 <= "00000";
    s_RA2 <= "00001";
    wait for cCLK_PER;



    -- Read back: rs1=x2, rs2=x0
    s_RA1 <= "00010";
    s_RA2 <= "00000";
    wait for cCLK_PER;



    -- Overwrite x1 = 0xF0F0F0F0 and read simultaneously (x1, x2)
    s_WE  <= '1';
    s_WA  <= "00001";
    s_WD  <= x"F0F0F0F0";
    wait for cCLK_PER;

    s_WE  <= '0';
    s_RA1 <= "00001";
    s_RA2 <= "00010";
    wait for cCLK_PER;


    wait;
  end process;

end behavior;
