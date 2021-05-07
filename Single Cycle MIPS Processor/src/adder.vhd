library IEEE;
use IEEE.std_logic_1164.all;

entity adder is 
    port(i_A  :  in std_logic;
		 i_B  :  in std_logic;
		 i_Cin  :  in std_logic;
		 o_S  : out std_logic;
		 o_Cout  : out std_logic);

end adder;

architecture structure of adder is

component xorg2
	port(i_A  :  in std_logic;
	     i_B  :  in std_logic;
		 o_F  :  out std_logic);
end component;

component andg2
	port(i_A  :  in std_logic;
		 i_B  :  in std_logic;
		 o_F  :  out std_logic);
end component;

component org2
	port(i_A  :  in std_logic;
		 i_B  :  in std_logic;
		 o_F  :  out std_logic);
end component;

signal xor_AB, and_ABC, and_AB: std_logic;

begin

--------------------------------------
	--First XOR Gate--
--------------------------------------
xor_1: xorg2

port map(i_A => i_A,
	i_B => i_B,
	o_F => xor_AB);

--------------------------------------
	--Second XOR Gate--
--------------------------------------
xor_2: xorg2

port map(i_A => xor_AB,
	i_B => i_Cin,
	o_F => o_S);
	
--------------------------------------
	--First AND Gate--
--------------------------------------
and_1: andg2

port map(i_A => xor_AB,
	i_B => i_Cin,
	o_F => and_ABC);

--------------------------------------
	--Second AND Gate--
--------------------------------------
and_2: andg2

port map(i_A => i_A,
	i_B => i_B,
	o_F => and_AB);

--------------------------------------
	--OR Gate--
--------------------------------------
or_1: org2

port map(i_A => and_ABC,
	i_B => and_AB,
	o_F => o_Cout);
	
end structure;