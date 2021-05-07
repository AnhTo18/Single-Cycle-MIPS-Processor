--Overflow detection

library IEEE;
use IEEE.std_logic_1164.all;

entity overflow_detector is

   port(i_A		: in std_logic;
	i_B		: in std_logic;
	i_sum		: in std_logic;
	o_overflow	: out std_logic);

end overflow_detector;

architecture dataflow of overflow_detector is
begin
process(i_A, i_B, i_sum)
   begin
	if (i_A = i_B) and (i_A /= i_sum) then
		o_overflow <= '1';
	else
		o_overflow <= '0';
	end if;	
end process;

end dataflow;