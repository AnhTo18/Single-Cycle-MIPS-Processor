--mux7_1_4bitselect
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity MUX12_1_5bitSelect is

	port(	i_OR : in std_logic_vector(31 downto 0);
	     	i_NOR: in std_logic_vector(31 downto 0);
			i_AND : in std_logic_vector(31 downto 0);
			i_XOR  : in std_logic_vector(31 downto 0);
			i_ADDER : in std_logic_vector(31 downto 0);
			i_SUB : in std_logic_vector(31 downto 0);
			i_SLL : in std_logic_vector(31 downto 0);
			i_SRL : in std_logic_vector(31 downto 0);
			i_SRA : in std_logic_vector(31 downto 0);
			i_SLT : in std_logic_vector(31 downto 0);
			i_CLO : in std_logic_vector(31 downto 0);
			i_CLZ : in std_logic_vector(31 downto 0);
			i_LUI : in std_logic_vector(31 downto 0);
			
			i_OPERATION : in std_logic_vector(4 downto 0);
	
			o_RESULT : out std_logic_vector(31 downto 0));

end MUX12_1_5bitSelect;

architecture dataflow of MUX12_1_5bitSelect is

begin
with i_OPERATION select
	
	O_Result <= i_OR when "00000",
				i_NOR when "00001",
				i_AND when "00010",
				i_XOR when "00011",
				i_ADDER when "00100",
				i_SUB when "10100",
				i_SLL when "00110",
				i_SRL when "00111",
				i_SRA when "01000",
				i_SLT when "11001",
				i_CLO when "01010",
				i_CLZ when "01011",
				i_LUI when "11111",
				"00000000000000000000000000000000" when others;
	
	
	

end dataflow;