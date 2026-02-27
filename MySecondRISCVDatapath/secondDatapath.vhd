--Author John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity secondDatapath is
	port(
       i_CLK   : in  std_logic;
       i_RST   : in  std_logic;
       i_WE    : in  std_logic;  
       i_ALUSrc: in  std_logic; --0=reg, 1=imm
       i_nAdd_Sub:in  std_logic;  -- 0=add, 1=sub
       i_MemWrite:in std_logic; --memory write enable
       i_MemToReg: in std_logic; -- 0=store alu result, 1=store memory result into register. 
       i_Extend: in std_logic; -- 0=0extend, 1=sign extend

       i_WA    : in  std_logic_vector(5-1 downto 0); -- rd
       i_RA1   : in  std_logic_vector(5-1 downto 0);   -- rs1
       i_RA2   : in  std_logic_vector(5-1 downto 0);   -- rs2
       i_Imm12   : in  std_logic_vector(12-1 downto 0); 

       o_Result: out std_logic_vector(32-1 downto 0);
       o_Cout  : out std_logic;
       o_RD1   : out std_logic_vector(32-1 downto 0); 
       o_RD2   : out std_logic_vector(32-1 downto 0); 
       o_MemQ   : out std_logic_vector(32-1 downto 0); 
       o_WD   : out std_logic_vector(32-1 downto 0)); 
end secondDatapath;

architecture structural of secondDatapath is

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

component mux2t1_N is
  generic(N : integer := 32);
    port(
    i_S : in std_logic;
    i_D0: in std_logic_vector(N-1 downto 0);
    i_D1: in std_logic_vector(N-1 downto 0);
    o_O:  out std_logic_vector(N-1 downto 0));
end component;

component mem is
  generic(
  DATA_WIDTH : natural := 32;
  ADDR_WIDTH : natural := 10);
  port(
	clk		: in std_logic;
	addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

component extender12t32 is
port(
   i_IN : in  std_logic_vector(12-1 downto 0);
   i_S  : in  std_logic; -- 0=zero extend, 1=sign extend
   o_OUT: out std_logic_vector(32-1 downto 0));
end component;

signal s_RD1   : std_logic_vector(32-1 downto 0); -- read data 1 for input to addsub
signal s_RD2   : std_logic_vector(32-1 downto 0); -- read data 2 for input to addsub
signal s_Imm32 : std_logic_vector(32-1 downto 0);
signal s_Result: std_logic_vector(32-1 downto 0); -- addsub output to be ouputted as well as inputted into regfile. 
signal s_Cout  : std_logic;
signal s_MemQ  : std_logic_vector(32-1 downto 0);
signal s_WD    : std_logic_vector(32-1 downto 0);
signal s_MemAddr: std_logic_vector(10-1 downto 0); --10 bit signal for addr value in mem block

begin 

U_REGFILE: regfile
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_RA1 => i_RA1, 
    i_RA2 => i_RA2,
    i_WA  => i_WA,
    i_WD  => s_WD,
    o_RD1 => s_RD1,
    o_RD2 => s_RD2);

U_EXT: extender12t32
  port map(
    i_IN => i_Imm12,
     i_S => i_Extend,
     o_OUT => s_Imm32);


U_ADDSUB: AddSub
  port map(
  i_A => s_RD1, 
  i_B => S_RD2, 
  i_Imm => s_Imm32, 
  i_ALUSrc => i_ALUSrc,
  i_nAdd_Sub => i_nAdd_Sub,
  o_Result => s_Result,
  o_Cout => s_Cout);

s_MemAddr <= s_Result(11 downto 2); --assigns memory address to leading 10 bits for memory indexing

dmem: mem
 generic map(
   DATA_WIDTH => 32,
   ADDR_WIDTH => 10)
 port map(
   clk => i_CLK,
   addr => s_MemAddr,
   data => s_RD2, --data comes from RD2 
   we => i_MemWrite, --store enable
   q => s_MemQ); 

--mux for writeback to register input WD

U_WBMUX: mux2t1_N
 generic map (
   N=> 32)
 port map(
    i_S => i_MemToReg,
    i_D0 =>s_Result,
    i_D1 => s_MemQ,
    o_O => s_WD);


--additional outputs
 o_Result <= s_Result;
 o_Cout <= s_Cout;
 o_RD1 <= s_RD1;
 o_RD2 <= s_RD2;
 o_MemQ <= s_MemQ;
 o_WD <= s_WD;
end structural; 







    
