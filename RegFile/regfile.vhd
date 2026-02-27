--Author John Murphy, structural regfile 32x32 registers
library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
    port(i_CLK   : in  std_logic;
    i_RST   : in  std_logic;
    i_WE    : in  std_logic; -- regWrite
    i_WA    : in  std_logic_vector(5-1 downto 0); -- rd
    i_RA1   : in  std_logic_vector(5-1 downto 0); -- rs1
    i_RA2   : in  std_logic_vector(5-1 downto 0); -- rs2
    i_WD    : in  std_logic_vector(32-1 downto 0); -- write data
    o_RD1   : out std_logic_vector(32-1 downto 0); -- read data 1
    o_RD2   : out std_logic_vector(32-1 downto 0)); -- read data 2
end regfile;

architecture structural of regfile is

  component decoder5t32 is
    port(i_IN  : in  std_logic_vector(5-1 downto 0);
       i_OUT : out std_logic_vector(32-1 downto 0));
  end component;

  component dffg_n is
    generic(N : integer := 32);
      port(i_CLK : in  std_logic;
      i_RST : in  std_logic;
      i_WE  : in  std_logic;
      i_D   : in  std_logic_vector(N-1 downto 0);
      o_Q   : out std_logic_vector(N-1 downto 0));
  end component;

  component mux32t1_n is
    generic(N : integer := 32);
    port(i_S  : in  std_logic_vector(5-1 downto 0);
    i_D0 : in  std_logic_vector(N-1 downto 0);
    i_D1 : in  std_logic_vector(N-1 downto 0);
    i_D2 : in  std_logic_vector(N-1 downto 0);
    i_D3 : in  std_logic_vector(N-1 downto 0);
    i_D4 : in  std_logic_vector(N-1 downto 0);
    i_D5 : in  std_logic_vector(N-1 downto 0);
    i_D6 : in  std_logic_vector(N-1 downto 0);
    i_D7 : in  std_logic_vector(N-1 downto 0);
    i_D8 : in  std_logic_vector(N-1 downto 0);
    i_D9 : in  std_logic_vector(N-1 downto 0);
    i_D10: in  std_logic_vector(N-1 downto 0);
    i_D11: in  std_logic_vector(N-1 downto 0);
    i_D12: in  std_logic_vector(N-1 downto 0);
    i_D13: in  std_logic_vector(N-1 downto 0);
    i_D14: in  std_logic_vector(N-1 downto 0);
    i_D15: in  std_logic_vector(N-1 downto 0);
    i_D16: in  std_logic_vector(N-1 downto 0);
    i_D17: in  std_logic_vector(N-1 downto 0);
    i_D18: in  std_logic_vector(N-1 downto 0);
    i_D19: in  std_logic_vector(N-1 downto 0);
    i_D20: in  std_logic_vector(N-1 downto 0);
    i_D21: in  std_logic_vector(N-1 downto 0);
    i_D22: in  std_logic_vector(N-1 downto 0);
    i_D23: in  std_logic_vector(N-1 downto 0);
    i_D24: in  std_logic_vector(N-1 downto 0);
    i_D25: in  std_logic_vector(N-1 downto 0);
    i_D26: in  std_logic_vector(N-1 downto 0);
    i_D27: in  std_logic_vector(N-1 downto 0);
    i_D28: in  std_logic_vector(N-1 downto 0);
    i_D29: in  std_logic_vector(N-1 downto 0);
    i_D30: in  std_logic_vector(N-1 downto 0);
    i_D31: in  std_logic_vector(N-1 downto 0);
    o_O  : out std_logic_vector(N-1 downto 0));
  end component;

  type reg_array_t is array(31 downto 0) of std_logic_vector(32-1 downto 0); --array(32x32) of register data

  signal s_dec  : std_logic_vector(32-1 downto 0); --decoder select signal
  signal s_regs : reg_array_t;  --32x32bit registers. s_regs(0) would contain x0 for instance. 
  signal s_we_r : std_logic_vector(31 downto 0); --per register write enable

begin

  -- Decode write address into 1-hot
  DEC: decoder5t32
  port map(i_IN  => i_WA,
         i_OUT => s_dec);

  -- x0 is hard-wired to 0
  s_regs(0) <= (others => '0');
  s_we_r(0) <= '0';

  -- Create per-register write enables (x1-x31)
  GEN_WE: for i in 1 to 31 generate
    s_we_r(i) <= i_WE and s_dec(i);
  end generate GEN_WE;

  -- Instantiate registers x1-x31
  GEN_REGS: for i in 1 to 31 generate
    REGI: dffg_n
      generic map(N => 32)
      port map(i_CLK => i_CLK,
          i_RST => i_RST,
          i_WE  => s_we_r(i),
          i_D   => i_WD,
          o_Q   => s_regs(i));
  end generate GEN_REGS;

  -- Read port 1 mux (rs1)
  MUX_RS1: mux32t1_n
    generic map(N => 32)
    port map(i_S   => i_RA1,
      i_D0  => s_regs(0),
      i_D1  => s_regs(1),
      i_D2  => s_regs(2),
      i_D3  => s_regs(3),
      i_D4  => s_regs(4),
      i_D5  => s_regs(5),
      i_D6  => s_regs(6),
      i_D7  => s_regs(7),
      i_D8  => s_regs(8),
      i_D9  => s_regs(9),
      i_D10 => s_regs(10),
      i_D11 => s_regs(11),
      i_D12 => s_regs(12),
      i_D13 => s_regs(13),
      i_D14 => s_regs(14),
      i_D15 => s_regs(15),
      i_D16 => s_regs(16),
      i_D17 => s_regs(17),
      i_D18 => s_regs(18),
      i_D19 => s_regs(19),
      i_D20 => s_regs(20),
      i_D21 => s_regs(21),
      i_D22 => s_regs(22),
      i_D23 => s_regs(23),
      i_D24 => s_regs(24),
      i_D25 => s_regs(25),
      i_D26 => s_regs(26),
      i_D27 => s_regs(27),
      i_D28 => s_regs(28),
      i_D29 => s_regs(29),
      i_D30 => s_regs(30),
      i_D31 => s_regs(31),
      o_O   => o_RD1);

  -- Read port 2 mux (rs2)
  MUX_RS2: mux32t1_n
    generic map(N => 32)
    port map(i_S   => i_RA2,
      i_D0  => s_regs(0),
      i_D1  => s_regs(1),
      i_D2  => s_regs(2),
      i_D3  => s_regs(3),
      i_D4  => s_regs(4),
      i_D5  => s_regs(5),
      i_D6  => s_regs(6),
      i_D7  => s_regs(7),
      i_D8  => s_regs(8),
      i_D9  => s_regs(9),
      i_D10 => s_regs(10),
      i_D11 => s_regs(11),
      i_D12 => s_regs(12),
      i_D13 => s_regs(13),
      i_D14 => s_regs(14),
      i_D15 => s_regs(15),
      i_D16 => s_regs(16),
      i_D17 => s_regs(17),
      i_D18 => s_regs(18),
      i_D19 => s_regs(19),
      i_D20 => s_regs(20),
      i_D21 => s_regs(21),
      i_D22 => s_regs(22),
      i_D23 => s_regs(23),
      i_D24 => s_regs(24),
      i_D25 => s_regs(25),
      i_D26 => s_regs(26),
      i_D27 => s_regs(27),
      i_D28 => s_regs(28),
      i_D29 => s_regs(29),
      i_D30 => s_regs(30),
      i_D31 => s_regs(31),
      o_O   => o_RD2);

end structural;
