library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is  

  port(i_OperandA : in std_logic;
       i_OperandB : in std_logic;
       i_Carry    : in std_logic;
       o_Sum      : out std_logic;
       o_Carry    : out std_logic);
       
end FullAdder;

architecture structure of FullAdder is

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal output_Xor1, output_And1, output_And2 : std_logic;

begin
  
  g_And2_1 : andg2
    port map(i_A => i_OperandA,
             i_B => i_OperandB,
             o_F => output_And1);
              
  g_And2_2 : andg2
    port map(i_A => output_Xor1,
             i_B => i_Carry,
             o_F => output_And2);
              
  g_Xor2_1 : xorg2
    port map(i_A => i_OperandA,
             i_B => i_OperandB,
             o_F => output_Xor1);
  
  g_Xor2_2 : xorg2
    port map(i_A => output_Xor1,
             i_B => i_Carry,
             o_F => o_Sum);
             
  g_Or2 : org2
    port map(i_A => output_And1,
             i_B => output_And2,
             o_F => o_Carry);                 
    
              
  
end structure;

