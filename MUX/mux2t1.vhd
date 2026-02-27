library IEEE;
use IEEE.std_logic_1164.all;
entity mux2t1 is 
	port(i_D0 : in std_logic;
	i_D1 : in std_logic;
	i_S  : in std_logic;
	o_O : out std_logic);
end mux2t1;
architecture structural of mux2t1 is

	--o_0 <= (i_D0 and not i_S) or (i_D1 and i_S);
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
component invg is
port(i_A : in std_logic;
	o_F : out std_logic);
end component;

signal n_s : std_logic;
signal s_D0 : std_logic;
signal s_D1 : std_logic;
begin
not_1 : invg
port map(i_A =>i_S, 
	o_F => n_s);

and_1 : andg2
port map(i_A => i_D0,
	i_B => n_s,
	o_F => s_D0);
and_2 : andg2
port map(i_A => i_D1,
	i_B => i_S,
	o_F => s_D1);
or_1: org2
port map(i_A => s_D0,
	i_B => s_D1,
	o_F => o_O);



end structural;