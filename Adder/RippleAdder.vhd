library IEEE;
use IEEE.std_logic_1164.all;

entity RippleAdder is
  generic(N : integer := 32);
  port(
    i_A   : in  std_logic_vector(N-1 downto 0);
    i_B   : in  std_logic_vector(N-1 downto 0);
    i_Cin : in  std_logic;
    o_S   : out std_logic_vector(N-1 downto 0);
    o_Cout: out std_logic
  );
end RippleAdder;

architecture structural of RippleAdder is

  component FullAdder is
    port(
      i_A   : in  std_logic;
      i_B   : in  std_logic;
      i_Cin : in  std_logic;
      o_S   : out std_logic;
      o_Cout: out std_logic
    );
  end component;

  
  signal c : std_logic_vector(N downto 0);

begin

  c(0) <= i_Cin;
  o_Cout <= c(N);
  --carry chain to link the adders
  G_RIPPLE : for i in 0 to N-1 generate
    FA : FullAdder
      port map(
        i_A   => i_A(i),
        i_B   => i_B(i),
        i_Cin => c(i),
        o_S   => o_S(i),
        o_Cout=> c(i+1)
      );
  end generate;

end structural;
