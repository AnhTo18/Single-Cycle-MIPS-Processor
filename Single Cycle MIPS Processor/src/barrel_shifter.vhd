--barrel shifer--

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
   port(
	i_shamt	: in std_logic_vector(4 downto 0);		--Amount to shift
	i_data	: in std_logic_vector(31 downto 0);		--Input Data
	i_Right_Or_Left : in std_logic;					--0 is Right 1 is Left
	i_bit	: in std_logic;							--Arithmetic or Logic Shift						--
	o_data	: out std_logic_vector(31 downto 0)); 	--Output Data					

end barrel_shifter;

architecture BarrelArch of barrel_shifter is

component mux2t1_thai
   port(
	i_A : in std_logic; --Input A
	i_B : in std_logic; --Input B
	i_Select : in std_logic; --select
	o_F : out std_logic); --output
end component;

signal s_row1, s_row2, s_row3, s_row4	: std_logic_vector(31 downto 0);	--Signals to carry over to new Muxes
signal s_bit	: std_logic;	--
signal s_data 	: std_logic_vector(31 downto 0);
signal s_Inversion_Going_Left : std_logic_vector(31 downto 0);
signal s_Second_Inversion	: std_logic_vector(31 downto 0);
signal s_Final_Data			: std_logic_vector(31 downto 0);
begin

--if Shift Right Logic then we shift in a 0 [if i_Bit is 0]
--If Shift Right Arithmetic, then we use our shifting bit as the MSB of Data [if i_Bit is 1]

process(i_bit,i_data,i_Right_Or_Left)
begin
   if i_bit = '0' or i_Right_Or_Left = '1' then
	s_bit <= '0';
   else
	s_bit <= i_data(31);
   end if;
end process;


--if Shift Left Anything, Invert all the Bits into a new Signal and pump it into s_data
inversion: for i in 0 to 31 generate

	s_Inversion_Going_Left(i) <= i_data(31-i);
	
	end generate inversion;

process(i_Right_Or_Left, s_data,s_Inversion_Going_Left)
begin
	if i_Right_Or_Left = '1' then
	 s_data <= s_Inversion_Going_Left;
	else
	 s_data <= i_data;
	end if;
end process;




--Row 1 of MUXes
Gen_row1: for i in 0 to 31 generate
	Upper_Mux1: if i = 31 generate
		m10: MUX2t1_thai port map
			(s_data(i),s_bit, i_shamt(0),s_row1(i));
	end generate Upper_Mux1;
	
	Lower_Muxs1: if i < 31 generate
		m11: MUX2t1_thai port map
			(s_data(i), s_data(i+1),i_shamt(0),s_row1(i));
	end generate Lower_Muxs1;
end generate Gen_row1;

--Row 2 of MUXes 
Gen_row2: for i in 0 to 31 generate
	Upper_Mux2: if i > 29 generate
		m20: MUX2t1_thai port map
			(s_row1(i),s_bit, i_shamt(1),s_row2(i));
	end generate Upper_Mux2;
	
	Lower_Muxs2: if i < 30 generate
		m21: MUX2t1_thai port map
			(s_row1(i), s_row1(i+2),i_shamt(1),s_row2(i));
	end generate Lower_Muxs2;
end generate Gen_row2;
	
--Row 3 of MUXes
Gen_row3: for i in 0 to 31 generate
	Upper_Mux3: if i > 27 generate
		m30: MUX2t1_thai port map
			(s_row2(i),s_bit, i_shamt(2),s_row3(i));
	end generate Upper_Mux3;
	
	Lower_Muxs3: if i < 28 generate
		m31: MUX2t1_thai port map
			(s_row2(i), s_row2(i+4),i_shamt(2),s_row3(i));
	end generate Lower_Muxs3;
end generate Gen_row3;

--Row 4 of MUXes
Gen_row4: for i in 0 to 31 generate
	Upper_Mux4: if i > 23 generate
		m40: MUX2t1_thai port map
			(s_row3(i),s_bit, i_shamt(3),s_row4(i));
	end generate Upper_Mux4;
	
	Lower_Muxs4: if i < 24 generate
		m41: MUX2t1_thai port map
			(s_row3(i), s_row3(i+8),i_shamt(3),s_row4(i));
	end generate Lower_Muxs4;
end generate Gen_row4;

--Row 5 of MUXes
Gen_row5: for i in 0 to 31 generate
	Upper_Mux5: if i > 15 generate 
		m50: MUX2t1_thai port map
			(s_row4(i),s_bit, i_shamt(4), s_Final_Data(i));
	end generate Upper_Mux5;
	
	Lower_Muxs5: if i < 16 generate
		m51: MUX2t1_thai port map
			(s_row4(i), s_row4(i+16),i_shamt(4), s_Final_Data(i));
	end generate Lower_Muxs5;
end generate Gen_row5;

second_inversion: for i in 0 to 31 generate
	s_Second_Inversion(i) <= s_Final_Data(31-i);
end generate;


process(i_Right_Or_Left, s_Final_Data, s_Second_Inversion)
begin
	if i_Right_Or_Left = '1' then
	 o_data <= s_Second_Inversion;
	else
	 o_data <= s_Final_Data;
	end if;
end process;


end BarrelArch;