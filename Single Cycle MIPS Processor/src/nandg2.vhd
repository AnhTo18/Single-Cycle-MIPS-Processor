library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity nandg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end nandg2;

architecture dataflow of nandg2 is
begin

  o_F <=  not (i_A and i_B);
  
end dataflow;