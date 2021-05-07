library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_N is
  port(i_s           : in  std_logic_vector(4 downto 0);  
       i_1           : in  std_logic_vector(31 downto 0);
       i_2           : in  std_logic_vector(31 downto 0);
       i_3           : in  std_logic_vector(31 downto 0);
       i_4           : in  std_logic_vector(31 downto 0);
       i_5           : in  std_logic_vector(31 downto 0);
       i_6           : in  std_logic_vector(31 downto 0);
       i_7           : in  std_logic_vector(31 downto 0); 
       i_8           : in  std_logic_vector(31 downto 0);
       i_9           : in  std_logic_vector(31 downto 0);
       i_A           : in  std_logic_vector(31 downto 0);
       i_B           : in  std_logic_vector(31 downto 0);
       i_C           : in  std_logic_vector(31 downto 0);
       i_D           : in  std_logic_vector(31 downto 0);
       i_E           : in  std_logic_vector(31 downto 0); 
       i_F           : in  std_logic_vector(31 downto 0);
       i_10          : in  std_logic_vector(31 downto 0);
       i_11          : in  std_logic_vector(31 downto 0);
       i_12          : in  std_logic_vector(31 downto 0);
       i_13          : in  std_logic_vector(31 downto 0);
       i_14          : in  std_logic_vector(31 downto 0);
       i_15          : in  std_logic_vector(31 downto 0); 
       i_16          : in  std_logic_vector(31 downto 0);
       i_17          : in  std_logic_vector(31 downto 0);
       i_18          : in  std_logic_vector(31 downto 0);
       i_19          : in  std_logic_vector(31 downto 0);
       i_1A          : in  std_logic_vector(31 downto 0);
       i_1B          : in  std_logic_vector(31 downto 0);
       i_1C          : in  std_logic_vector(31 downto 0); 
       i_1D          : in  std_logic_vector(31 downto 0);
       i_1E          : in  std_logic_vector(31 downto 0); 
       i_1F          : in  std_logic_vector(31 downto 0);
       i_20          : in  std_logic_vector(31 downto 0); 
       o_F           : out std_logic_vector(31 downto 0));   
 end mux32t1_N;

architecture dataflow of mux32t1_N is
  
begin
  
  with i_s select o_F <=
        i_1 when "00000",
        i_2 when "00001",
        i_3 when "00010",
        i_4 when "00011",
        i_5 when "00100",
        i_6 when "00101",
        i_7 when "00110",
        i_8 when "00111", 
        i_9 when "01000",
        i_A when "01001",
        i_B when "01010",
        i_C when "01011",
        i_D when "01100",
        i_E when "01101",
        i_F when "01110",
        i_10 when "01111", 
        i_11 when "10000",
        i_12 when "10001",
        i_13 when "10010",
        i_14 when "10011",
        i_15 when "10100",
        i_16 when "10101",
        i_17 when "10110",
        i_18 when "10111", 
        i_19 when "11000",
        i_1A when "11001",
        i_1B when "11010",
        i_1C when "11011",
        i_1D when "11100",
        i_1E when "11101",
        i_1F when "11110",
        i_20 when "11111",
        x"00000000" when others;
  
end dataflow;