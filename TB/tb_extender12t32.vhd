--Author John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_extender12t32 is
end tb_extender12t32;

architecture behavior of tb_extender12t32 is 
  component extender12t32 is
    port(
   i_IN : in  std_logic_vector(12-1 downto 0);
   i_S  : in  std_logic; -- 0=zero extend, 1=sign extend
   o_OUT: out std_logic_vector(32-1 downto 0));
  end component;

  signal s_IN : std_logic_vector(12-1 downto 0);
  signal s_S  : std_logic;
  signal s_OUT: std_logic_vector(32-1 downto 0);

  begin

 EXT: extender12t32
  port map(
    i_IN => s_IN,
    i_S => s_S, 
    o_OUT => s_OUT);

  P_TB: process
  begin

    --first testing zero extension
    s_S <= '0';

    s_IN <= x"000";
    wait for 100 ns;

    s_IN <= x"00F";
    wait for 100 ns;

    s_IN <= x"0FF";
    wait for 100 ns;

    s_IN <= x"FFF";
    wait for 100 ns;

    s_IN <= x"800";
    wait for 100 ns;

    --then testing sign extension on same data
    s_S <= '1';

    s_IN <= x"000";
    wait for 100 ns;

    s_IN <= x"00F";
    wait for 100 ns;

    s_IN <= x"0FF";
    wait for 100 ns;

    s_IN <= x"FFF";
    wait for 100 ns;

    s_IN <= x"800";
    wait for 100 ns;
    wait;
  end process;

end behavior;
