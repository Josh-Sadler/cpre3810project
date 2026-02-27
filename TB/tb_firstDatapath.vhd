--Author John Murphy
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_firstDatapath is
  generic(gCLK_HPER : time := 50 ns);
end tb_firstDatapath;

architecture behavior of tb_firstDatapath is

  
 constant cCLK_PER : time := gCLK_HPER * 2;

 component firstDatapath is
   port(
   i_CLK      : in  std_logic;
   i_RST      : in  std_logic;
   i_WE       : in  std_logic;
   i_ALUSrc   : in  std_logic;
   i_nAdd_Sub : in  std_logic;
   i_WA       : in  std_logic_vector(5-1 downto 0);
   i_RA1      : in  std_logic_vector(5-1 downto 0);
   i_RA2      : in  std_logic_vector(5-1 downto 0);
   i_Imm      : in  std_logic_vector(32-1 downto 0);

   o_Result   : out std_logic_vector(32-1 downto 0);
   o_Cout     : out std_logic;

   o_RD1      : out std_logic_vector(32-1 downto 0);
   o_RD2      : out std_logic_vector(32-1 downto 0));
  end component;

  -- Signals to be able to connect and operate the datapath. 
  signal s_CLK      : std_logic;
  signal s_RST      : std_logic;
  signal s_WE       : std_logic;
  signal s_ALUSrc   : std_logic;
  signal s_nAdd_Sub : std_logic;
  signal s_WA       : std_logic_vector(5-1 downto 0);
  signal s_RA1      : std_logic_vector(5-1 downto 0);
  signal s_RA2      : std_logic_vector(5-1 downto 0);
  signal s_Imm      : std_logic_vector(32-1 downto 0);

  signal s_Result   : std_logic_vector(32-1 downto 0);
  signal s_Cout     : std_logic;
  signal s_RD1      : std_logic_vector(32-1 downto 0);
  signal s_RD2      : std_logic_vector(32-1 downto 0);

begin

DUT: firstDatapath
  port map(
    i_CLK      => s_CLK,
    i_RST      => s_RST,
    i_WE       => s_WE,
    i_ALUSrc   => s_ALUSrc,
    i_nAdd_Sub => s_nAdd_Sub,
    i_WA       => s_WA,
    i_RA1      => s_RA1,
    i_RA2      => s_RA2,
    i_Imm      => s_Imm,
    o_Result   => s_Result,
    o_Cout     => s_Cout,
    o_RD1      => s_RD1,
    o_RD2      => s_RD2);

  -- clock setup
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- test area
  P_TB: process
  begin

    -- first reset the datapath sa a precaution
    s_RST      <= '1';
    s_WE       <= '0';
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_WA       <= "00000";
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_Imm      <= x"00000000";
    wait for cCLK_PER;

    s_RST <= '0';
    wait for cCLK_PER;

    
    -- addi x1, zero, 1 -> x1 = 1
    -- ALUSrc=1, nAdd_Sub=0, WE=1
    s_WE       <= '1';
    s_ALUSrc   <= '1';
    s_nAdd_Sub <= '0';
    s_RA1      <= "00000";   -- x0
    s_RA2      <= "00000";   -- ra2 value doesn't matter during imm calculations
    s_WA       <= "00001";   -- x1
    s_Imm      <= x"00000001";
    wait for cCLK_PER;


    -- addi x2, zero, 2 -> x2 = 2
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00010"; 
    s_Imm      <= x"00000002";
    wait for cCLK_PER;


    -- addi x3, zero, 3 -> x3 = 3
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00011";   -- x3
    s_Imm      <= x"00000003";
    wait for cCLK_PER;


    -- addi x4, zero, 4 -> x4 = 4
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00100"; 
    s_Imm      <= x"00000004";
    wait for cCLK_PER;


    -- addi x5, zero, 5 -> x5 = 5
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00101";   
    s_Imm      <= x"00000005";
    wait for cCLK_PER;


    -- addi x6, zero, 6 -> x6 = 6
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00110"; 
    s_Imm      <= x"00000006";
    wait for cCLK_PER;


    -- addi x7, x0, 7 -> x7 = 7
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "00111";
    s_Imm      <= x"00000007";
    wait for cCLK_PER;


    -- addi x8, zero, 8 -> x8 = 8
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "01000";
    s_Imm      <= x"00000008";
    wait for cCLK_PER;


    -- addi x9, zero, 9 -> x9 = 9
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "01001"; 
    s_Imm      <= x"00000009";
    wait for cCLK_PER;


    -- addi x10, zero, 10 -> x10 = 10
    s_RA1      <= "00000";
    s_RA2      <= "00000";
    s_WA       <= "01010"; 
    s_Imm      <= x"0000000A";
    wait for cCLK_PER;


    -- add x11, x1, x2 -> x11 = 1+2=3
    -- ALUSrc=0, nAdd_Sub=0 
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "00001"; -- x1
    s_RA2      <= "00010"; -- x2
    s_WA       <= "01011"; -- x11
    s_Imm      <= x"00000000";
    wait for cCLK_PER;


    -- sub x12, x11, x3 -> x12 = 3-3=0
    -- ALUSrc=0, nAdd_Sub=1
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '1';
    s_RA1      <= "01011"; -- x11
    s_RA2      <= "00011"; -- x3
    s_WA       <= "01100"; -- x12
    s_Imm      <= x"00000000";
    wait for cCLK_PER;


    -- add x13, x12, x4 -> x13 = 0+4=4
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "01100"; -- x12
    s_RA2      <= "00100"; -- x4
    s_WA       <= "01101"; -- x13
    wait for cCLK_PER;

    
    -- sub x14, x13, x5 -> x14 = 4-5= -1(0xFFFFFFFF)
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '1';
    s_RA1      <= "01101"; -- x13
    s_RA2      <= "00101"; -- x5
    s_WA       <= "01110"; -- x14
    wait for cCLK_PER;


    -- add x15, x14, x6 -> x15 = 6 + -1 = 5
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "01110"; -- x14
    s_RA2      <= "00110"; -- x6
    s_WA       <= "01111"; -- x15
    wait for cCLK_PER;


    -- sub x16, x15, x7 -> x16 = 5 - 7 = -2(0xFFFFFFFE)
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '1';
    s_RA1      <= "01111"; -- x15
    s_RA2      <= "00111"; -- x7
    s_WA       <= "10000"; -- x16
    wait for cCLK_PER;


    -- add x17, x16, x8 -> x17 = -2 + 8 = 6
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "10000"; -- x16
    s_RA2      <= "01000"; -- x8
    s_WA       <= "10001"; -- x17
    wait for cCLK_PER;


    -- sub x18, x17, x9 -> x18 = 6 - 9 = -3
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '1';
    s_RA1      <= "10001"; -- x17
    s_RA2      <= "01001"; -- x9
    s_WA       <= "10010"; -- x18
    wait for cCLK_PER;


    -- add x19, x18, x10 -> x19 = 10 + -3 = 7
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "10010"; -- x18
    s_RA2      <= "01010"; -- x10
    s_WA       <= "10011"; -- x19
    wait for cCLK_PER;


    -- addi x20, zero, -35 -> x20 = 0+ -35 =-35(0xFFFFFFDD)
    -- ALUSrc=1
    s_ALUSrc   <= '1';
    s_nAdd_Sub <= '0';
    s_RA1      <= "00000"; -- x0
    s_RA2      <= "00000"; -- don't care for ALUSrc=1
    s_WA       <= "10100"; -- x20
    s_Imm      <= x"FFFFFFDD";
    wait for cCLK_PER;

    
    -- add x21, x19, x20 -> x21 = 7 + -35 = -28(0xFFFFFFE4)
    s_ALUSrc   <= '0';
    s_nAdd_Sub <= '0';
    s_RA1      <= "10011"; -- x19
    s_RA2      <= "10100"; -- x20
    s_WA       <= "10101"; -- x21
    s_Imm      <= x"00000000";
    wait for cCLK_PER;

    
    -- disabling write to read back some values for the waveform. 
    s_WE <= '0';

    -- Read x19 and x21
    s_RA1 <= "10011"; -- x19 = 7
    s_RA2 <= "10101"; -- x21 = -28
    wait for cCLK_PER;

    -- Read x0 and x20
    s_RA1 <= "00000"; -- x0 = 0
    s_RA2 <= "10100"; -- x20 = -35
    wait for cCLK_PER;

    -- Read x14 and x16
    s_RA1 <= "01110"; -- x14 = -1
    s_RA2 <= "10000"; -- x16 = -2
    wait for cCLK_PER;

    wait;
  end process;

end behavior;
