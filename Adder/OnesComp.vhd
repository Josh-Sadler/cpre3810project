library IEEE;
use IEEE.std_logic_1164.all;

entity OnesComp is
  generic( N : positive := 32);
  port(
    i_A : in  std_logic_vector(N-1 downto 0);
    o_F : out  std_logic_vector(N-1 downto 0));
end entity OnesComp;

architecture structural of OnesComp is
  component invg is
    port(
      i_A : in std_logic;
      o_F : out std_logic);
  end component;
begin
G_NBit_INV : for i in 0 to N-1 generate
  INVI : invg
    port map(
      i_A => i_A(i), 
      o_F => o_F(i));
  end generate G_NBit_INV;
end structural;