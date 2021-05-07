-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end mux2t1_N;

architecture structural of mux2t1_N is

  component mux2t1 is
    port(i_A                  : in std_logic;
         i_B                 : in std_logic;
         i_C                 : in std_logic;
         o_F                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_MUX: for i in 0 to N-1 generate
    MUXI: mux2t1 port map(
              i_A      => i_D0(i),     
              i_B     => i_D1(i),  
              i_C     => i_S,  
              o_F      => o_O(i));  
  end generate G_NBit_MUX;
  
end structural;
