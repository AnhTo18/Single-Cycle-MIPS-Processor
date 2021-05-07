library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer2_1 is
  generic(N : integer := 14);
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Select : in std_logic;
       o_F  : out std_logic);

end multiplexer2_1;

architecture structure of multiplexer2_1 is

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

signal not_A, and_A, and_B: std_logic;

begin

not_1: invg
--------------------------------------
	--Not Gate--
--------------------------------------
port map(i_A => i_Select,
	 o_F => not_A);
--------------------------------------
	--First And Gate--
--------------------------------------
u1: andg2
port map(i_A => i_A,
	 i_B => not_A,
	 o_F => and_A);
-------------------------------------
	--Second And Gate--
-------------------------------------
u2 : andg2
port map(i_A => i_Select,
	 i_B => i_B,
	 o_F => and_B);
-------------------------------------
	--or Gate--
-------------------------------------
u3 : org2

port map(i_A => and_A,
	 i_B => and_B,
	 o_F => o_F);

end structure;

