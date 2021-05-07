library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_Nbit is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Select : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end mux2t1_Nbit;

architecture structure of mux2t1_NBit is

component andg2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
end component;

component org2
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
end component;

component invg
  port(i_A  : in std_logic;
       o_F  : out std_logic);
end component;

signal not_A : std_logic;
signal and_A, and_B: std_logic_vector(N-1 downto 0);

begin
not_1: invg
--------------------------------------
	--Not Gate--
--------------------------------------
port map(i_A => i_Select,
	 o_F => not_A);	--Select--
G1: for i in 0 to N-1 generate


--------------------------------------
	--First And Gate--
--------------------------------------
u1: andg2
port map(i_A => i_A(i),
	 i_B => not_A,	--Select--
	 o_F => and_A(i));
-------------------------------------
	--Second And Gate--
-------------------------------------
u2 : andg2
port map(i_A => i_Select,
	 i_B => i_B(i),
	 o_F => and_B(i));
-------------------------------------
	--or Gate--
-------------------------------------
u3 : org2

port map(i_A => and_A(i),
	 i_B => and_B(i),
	 o_F => o_F(i));

end generate;

end structure;
