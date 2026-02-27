library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_df is
  port(
    i_D0 : in std_logic;
    i_D1 : in std_logic;
    i_S  : in std_logic;
    o_0  : out std_logic);
end mux2t1_df;
architecture dataflow of mux2t1_df is
begin
  o_0 <= i_D0 when i_S = '0' else
    i_D1;
end dataflow;