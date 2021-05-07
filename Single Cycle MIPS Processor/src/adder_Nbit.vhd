	library IEEE;
	use IEEE.std_logic_1164.all;

entity adder_Nbit is
	generic(N : integer := 32);
	port(i_A  :  in std_logic_vector(N-1 downto 0);
		 i_B  :  in std_logic_vector(N-1 downto 0);
		 i_Cin  :  in std_logic;
		 o_S  : out std_logic_vector(N-1 downto 0);
		 o_Cout  : out std_logic);
		 
end adder_Nbit;

architecture structural of adder_Nbit is

component adder
	port(i_A  :  in std_logic;
		 i_B  :  in std_logic;
		 i_Cin  :  in std_logic;
		 o_S  : out std_logic;
		 o_Cout  : out std_logic);
end component;

signal s_Carry : std_logic_vector(N-1 downto 0);

begin

first_Adder: adder
	port map(i_A => i_A(0),
			 i_B => i_B(0),
			 i_Cin => i_Cin,
			 o_S => o_S(0),
			 o_Cout => s_Carry(0));
			 
G1: for i in 1 to N-2 generate

	n_adder: adder
		port map(i_A => i_A(i),
				 i_B => i_B(i),
				 i_Cin => s_Carry(i-1),
				 o_S => o_S(i),
				 o_Cout => s_Carry(i));

end generate;

last_adder: adder
	port map(i_A => i_A(N-1),
			 i_B => i_B(N-1),
			 i_Cin => s_Carry(N-2),
			 o_S => o_S(N-1),
			 o_Cout => o_Cout);
			 
end structural;