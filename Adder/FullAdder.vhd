library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
  port(
    i_A   : in  std_logic;
    i_B   : in  std_logic;
    i_Cin : in  std_logic;
    o_S   : out std_logic;
    o_Cout: out std_logic
  );
end FullAdder;

architecture structural of FullAdder is

  component xorg2 is
    port(i_A : in std_logic;
         i_B : in std_logic;
         o_F : out std_logic);
  end component;

  component andg2 is
    port(i_A : in std_logic;
         i_B : in std_logic;
         o_F : out std_logic);
  end component;

  component org2 is
    port(i_A : in std_logic;
         i_B : in std_logic;
         o_F : out std_logic);
  end component;

  signal s_X1  : std_logic;
  signal s_A1  : std_logic;
  signal s_A2  : std_logic;

begin

  -- X1 = A xor B
  gate1: xorg2 port map(i_A => i_A, i_B => i_B, o_F => s_X1);

  -- S = X1 xor Cin
  gate2: xorg2 port map(i_A => s_X1, i_B => i_Cin, o_F => o_S);

  -- A1 = A and B
  gate3: andg2 port map(i_A => i_A, i_B => i_B, o_F => s_A1);

  -- A2 = Cin and X1
  gate4: andg2 port map(i_A => i_Cin, i_B => s_X1, o_F => s_A2);

  -- Cout = A1 or A2
  gate5: org2  port map(i_A => s_A1, i_B => s_A2, o_F => o_Cout);

end structural;