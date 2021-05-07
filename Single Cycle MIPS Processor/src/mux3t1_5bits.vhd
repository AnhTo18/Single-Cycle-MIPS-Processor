library IEEE;
use IEEE.std_logic_1164.all;

entity mux3t1_5bits is
  generic(N : integer := 5);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
	   i_C		: in std_logic_vector(N-1 downto 0);
       i_s	    : in std_logic_vector(1 downto 0);
       o_F	   : out std_logic_vector(N-1 downto 0));

end mux3t1_5bits;

architecture dataflow of mux3t1_5bits is

begin
with i_s select o_F <=
 i_A when "00",
 i_B when "01",
 i_C when others;
-- x"1F" when others;
 

end dataflow;