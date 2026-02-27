library IEEE;
use IEEE.std_logic_1164.all;

entity AddSub is
  generic(N : integer := 32);
  port(
    i_A       : in  std_logic_vector(N-1 downto 0);
    i_B       : in  std_logic_vector(N-1 downto 0);
    i_Imm     : in  std_logic_vector(N-1 downto 0);
    i_ALUSrc  : in  std_logic;
    i_nAdd_Sub: in  std_logic;  
    o_Result  : out std_logic_vector(N-1 downto 0);
    o_Cout    : out std_logic
  );
end AddSub;

architecture structural of AddSub is

  component OnesComp is
    generic(N : integer := 32);
    port(
      i_A : in  std_logic_vector(N-1 downto 0);
      o_F : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N is
    generic(N : integer := 32);
    port(
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(N-1 downto 0);
      i_D1 : in  std_logic_vector(N-1 downto 0);
      o_O  : out std_logic_vector(N-1 downto 0));
  end component;

  component RippleAdder is
    generic(N : integer := 32);
    port(
      i_A   : in  std_logic_vector(N-1 downto 0);
      i_B   : in  std_logic_vector(N-1 downto 0);
      i_Cin : in  std_logic;
      o_S   : out std_logic_vector(N-1 downto 0);
      o_Cout: out std_logic);
  end component;

  signal s_BS : std_logic_vector(N-1 downto 0); --signal for B value after deciding to use B or imm
  signal s_BSneg : std_logic_vector(N-1 downto 0); --signal for second value input after 1s comp
  signal s_BO : std_logic_vector(N-1 downto 0); --signal that is output of mux that decides if we need complement or regular
begin


  --select ALU operand with mux
  U_SRCMUX: mux2t1_N
    generic map(N => N)
    port map(
      i_S => i_ALUSrc,
      i_D0 => i_B,
      i_D1 => i_Imm,
      o_O => s_BS);

  -- Invert input 2 using one's complement
  U_INV : OnesComp
    generic map(N => N)
    port map(
      i_A => s_BS,
      o_F => s_BSneg);

  --  Select add or subtract for input 2. 
  U_MUX : mux2t1_N
    generic map(N => N)
    port map(
      i_S  => i_nAdd_Sub,
      i_D0 => s_BS,
      i_D1 => s_BSneg,
      o_O  => s_BO);

  --  A +- B + Cin where Cin = nAdd_Sub
  --    If nAdd_Sub=0 -> A+B+0, if nAdd_Sub=1 -> A+(~B)+1 = A-B
  U_ADD : RippleAdder
    generic map(N => N)
    port map(
      i_A    => i_A,
      i_B    => s_BO,
      i_Cin  => i_nAdd_Sub,
      o_S    => o_Result,
      o_Cout => o_Cout);

end structural;