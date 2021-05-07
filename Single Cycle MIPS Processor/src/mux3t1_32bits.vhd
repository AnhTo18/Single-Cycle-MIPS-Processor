library IEEE;
use IEEE.std_logic_1164.all;

entity mux3t1_32bits is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
	   i_C		: in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic_vector(1 downto 0);
       o_Y          : out std_logic_vector(N-1 downto 0));

end mux3t1_32bits;

architecture dataflow of mux3t1_32bits is

begin
with i_X select o_Y <=
 i_A when "01",
 i_B when "00",
 i_C when others;
-- x"1F" when others;
 

end dataflow;