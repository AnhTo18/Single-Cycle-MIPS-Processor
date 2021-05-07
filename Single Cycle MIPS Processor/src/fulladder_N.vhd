library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_N  is 
 generic(N : integer := 32);
    port(a,b  : in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			cout: out std_logic;
			sum: out std_logic_vector(N-1 downto 0));
end fulladder_N;

architecture structural of fulladder_N is

component fulladder_anh is
    port(a,b,cin  : in std_logic;
			sum,cout: out std_logic);
end component;
signal t: std_logic_vector(31 downto 1);
begin
 fulladderI: fulladder_anh port map(
			a =>  a(0),
			b =>	b(0),
			cin =>  cin,
			sum =>  sum(0),
			cout => t(1));
 
 G_NBit_fulladder: for i in 1 to 30 generate
 fulladderQ: fulladder_anh port map(
			a =>  a(i),
			b =>	b(i),
			cin =>  t(i),
			sum =>  sum(i),
			cout => t(i+1));
 end generate G_NBit_fulladder;
 fulladderII: fulladder_anh port map(
			a =>  a(31),
			b =>	b(31),
			cin =>  t(31),
			sum =>  sum(31),
			cout => cout);
 
end structural;