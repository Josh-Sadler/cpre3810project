--Author John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder5t32 is
	generic(gCLK_HPER : time := 50 ns);
end tb_decoder5t32;

architecture behavior of tb_decoder5t32 is
constant cCLK_PER  : time := gCLK_HPER * 2;

component decoder5t32	
	port(i_IN : in std_logic_vector(5-1 downto 0);
	     i_OUT: out std_logic_vector(32-1 downto 0));
end component;

signal s_CLK : std_logic;
signal s_IN : std_logic_vector(5-1 downto 0);
signal s_OUT : std_logic_vector(32-1 downto 0);

begin

DUT: decoder5t32
port map(i_IN => s_IN,
	i_OUT => s_OUT);

P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
P_TB: process
begin

s_IN <= "00000";
wait for cCLK_PER;

s_IN <= "00001";
wait for cCLK_PER;

s_IN <= "00010";
wait for cCLK_PER;

s_IN <= "00011";
wait for cCLK_PER;

s_IN <= "00100";
wait for cCLK_PER;

s_IN <= "00101";
wait for cCLK_PER;

s_IN <= "00110";
wait for cCLK_PER;

s_IN <= "00111";
wait for cCLK_PER;

s_IN <= "01000";
wait for cCLK_PER;

s_IN <= "01001";
wait for cCLK_PER;

s_IN <= "01010";
wait for cCLK_PER;

s_IN <= "01011";
wait for cCLK_PER;

s_IN <= "01100";
wait for cCLK_PER;

s_IN <= "01101";
wait for cCLK_PER;

s_IN <= "01110";
wait for cCLK_PER;

s_IN <= "01111";
wait for cCLK_PER;

s_IN <= "10000";
wait for cCLK_PER;

s_IN <= "10001";
wait for cCLK_PER;

s_IN <= "10010";
wait for cCLK_PER;

s_IN <= "10011";
wait for cCLK_PER;

s_IN <= "10100";
wait for cCLK_PER;

s_IN <= "10101";
wait for cCLK_PER;

s_IN <= "10110";
wait for cCLK_PER;

s_IN <= "10111";
wait for cCLK_PER;

s_IN <= "11000";
wait for cCLK_PER;

s_IN <= "11001";
wait for cCLK_PER;

s_IN <= "11010";
wait for cCLK_PER;

s_IN <= "11011";
wait for cCLK_PER;

s_IN <= "11100";
wait for cCLK_PER;

s_IN <= "11101";
wait for cCLK_PER;

s_IN <= "11110";
wait for cCLK_PER;

s_IN <= "11111";
wait for cCLK_PER;

wait;
end process;
end behavior;
