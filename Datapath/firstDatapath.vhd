--Author John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity firstDatapath is
    port(
    i_CLK   : in  std_logic;
    i_RST   : in  std_logic;
    i_WE    : in  std_logic;  
    i_ALUSrc: in  std_logic;
    i_nAdd_Sub:in  std_logic; -- regWrite
    i_WA    : in  std_logic_vector(5-1 downto 0); -- rd
    i_RA1   : in  std_logic_vector(5-1 downto 0); -- rs1
    i_RA2   : in  std_logic_vector(5-1 downto 0); -- rs2
    i_Imm   : in  std_logic_vector(32-1 downto 0); 

    o_Result: out std_logic_vector(32-1 downto 0);
    o_Cout  : out std_logic;

    o_RD1   : out std_logic_vector(32-1 downto 0);  -- RD1/RD2 are unneeded outputs but useful
    o_RD2   : out std_logic_vector(32-1 downto 0)); 
end firstDatapath;

architecture structural of firstDatapath is

  component regfile is
    port(i_CLK   : in  std_logic;
    i_RST   : in  std_logic;
    i_WE    : in  std_logic;  -- regWrite
    i_WA    : in  std_logic_vector(5-1 downto 0); -- rd
    i_RA1   : in  std_logic_vector(5-1 downto 0); -- rs1
    i_RA2   : in  std_logic_vector(5-1 downto 0); -- rs2
    i_WD    : in  std_logic_vector(32-1 downto 0); -- write data
    o_RD1   : out std_logic_vector(32-1 downto 0); -- read data 1
    o_RD2   : out std_logic_vector(32-1 downto 0)); -- read data 2
end component;
     
component AddSub is 
  generic(N : integer := 32);
    port(
    i_A       : in  std_logic_vector(N-1 downto 0);
    i_B       : in  std_logic_vector(N-1 downto 0);
    i_Imm     : in  std_logic_vector(N-1 downto 0);
    i_ALUSrc  : in  std_logic;
    i_nAdd_Sub: in  std_logic;  
    o_Result  : out std_logic_vector(N-1 downto 0);
    o_Cout    : out std_logic);
end component;


signal s_RD1   : std_logic_vector(32-1 downto 0); -- read data 1 for input to addsub
signal s_RD2   : std_logic_vector(32-1 downto 0); -- read data 2 for input to addsub
signal s_Result: std_logic_vector(32-1 downto 0); -- addsub output to be ouputted as well as inputted into regfile. 
signal s_Cout  : std_logic;

begin 

U_REGFILE: regfile
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_RA1 => i_RA1, 
    i_RA2 => i_RA2,
    i_WA  => i_WA,
    i_WD  => s_result,
    o_RD1 => s_RD1,
    o_RD2 => s_RD2);


U_ADDSUB: AddSub
  port map(
  i_A => s_RD1, 
  i_B => S_RD2, 
  i_Imm => i_Imm, 
  i_ALUSrc => i_ALUSrc,
  i_nAdd_Sub => i_nAdd_Sub,
  o_Result => s_Result,
  o_Cout => s_Cout);

o_Result <= s_Result;
o_Cout <= s_Cout;
o_RD1 <= s_RD1;
o_RD2 <= s_RD2;
end structural; 







    
