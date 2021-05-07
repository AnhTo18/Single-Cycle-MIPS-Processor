library IEEE;
use IEEE.std_logic_1164.all;

entity addersub_N is
generic(N : integer := 32);
port(A, B       : in std_logic_vector(N-1 downto 0);
     nAdd_Sub, Cin   : in std_logic;
     output        : out std_logic_vector(N-1 downto 0);
	 Cout        : out std_logic);
	 

end addersub_N;

architecture structural of addersub_N is

component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;


component oneComp is
	generic(N : integer :=32);
	port(i_A	: in std_logic_vector(N-1 downto 0);
		 o_F	: out std_logic_vector(N-1 downto 0));

end component;

component fulladder_N  is 
 generic(N : integer := 32);
    port(a,b  : in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			cout: out std_logic;
			sum: out std_logic_vector(N-1 downto 0));
end component;

signal whatever: std_logic;
signal nB, s_Bcomp: std_logic_vector(N-1 downto 0);
signal to_add : std_logic_vector(N-1 downto 0);

begin

invert : oneComp
  port map(i_A => B,
           o_F => nB);


twoComp: fulladder_N
  port map(a =>nB,
           b => "00000000000000000000000000000001",
		   cin => '0',
			cout => whatever,
			sum =>  s_Bcomp);


mux : mux2t1_N
  port map(i_S => nAdd_Sub,
           i_D0 => B,
           i_D1 => s_Bcomp,
           o_O => to_add);

adder : fulladder_N
  port map(a => A,
           b => to_add,
           cin => Cin,
           cout => Cout,
           sum => output);
          

end structural;

