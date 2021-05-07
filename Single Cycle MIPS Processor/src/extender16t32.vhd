library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;


entity extender16t32 is 
  
  port(i  : in  std_logic_vector(15 downto 0);
       i_sign : in  std_logic;                    --'0' for zero    '1' for sign
       o: out std_logic_vector(31 downto 0));
end extender16t32;

architecture dataflow of extender16t32 is


signal s_signExtend, s_zeroExtend: std_logic_vector(31 downto 0);
begin
s_zeroExtend<= "0000000000000000"&i;
s_signExtend<= "1111111111111111"&i;

o<= s_zeroExtend when (i_sign='0' or i(15)='0') else
s_signExtend;

end dataflow;













