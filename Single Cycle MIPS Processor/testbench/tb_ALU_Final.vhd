library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALU_Final is

end tb_ALU_Final;

architecture behavior of tb_ALU_Final is



component ALU_Final 

	port(i_A : in std_logic_vector(31 downto 0);				--Read Register 1
		 i_B : in std_logic_vector(31 downto 0);				--Read Register 2
		 i_ALUSrc : in std_logic;								--ALU Source (Read Register 2 or Immediate)
		 i_ALUControl : in std_logic_vector(4 downto 0);		--What operation the ALU will Do
		 i_Immediate_or_Register : in std_logic;
		 i_immediate : in std_logic_vector(31 downto 0);		--Immediate Value
		 o_ALU_Result : out std_logic_vector(31 downto 0);		--Output Data 
		 o_Cout : out std_logic;
		 o_Zero : out std_logic);	--Resulting Data from ALU	--Carry Out we don't care that much about honestly
		 
		 
end component;

signal s_rs, s_rt : std_logic_vector(31 downto 0);	--RR1, RR2
signal s_imm : std_logic_vector(31 downto 0);		--Immediate value
signal s_ALUSrc	: std_logic;						--ALU Source Control
signal s_ALU_CTRL	: std_logic_vector(4 downto 0);	--Value to decide what operation we will be doing
signal s_ALU_Result : std_logic_vector(31 downto 0); --Resulting data
signal s_Cout		: std_logic;					--Carry Out
signal s_Immediate_or_Register :std_logic;
signal s_zero : std_logic;
--00000 0 is OR
--00001 1 is NOR
--00010 2 is AND
--00011 3 is XOR
--00100 4 is ADDER
--10100 20 is SUB
--00110 5 is SLL
--00111 7 is SRL
--01000 8 is SRA
--11001 25 is SLT
--01010 10 is CLO
--01011 11 is CLZ
--
--
--
--
--



begin

	DUT : ALU_Final
	port map(
		i_A => s_rs,
		i_B => s_rt,
		i_ALUSrc => s_ALUSrc,
		i_ALUControl => s_ALU_CTRL,
		i_Immediate_or_Register => s_Immediate_or_Register,
		i_immediate => s_imm,
		o_ALU_Result => s_ALU_Result,
		o_Zero => s_zero,
		o_Cout => s_Cout);
		
	test : process
	begin
	
	--SRLV--
	s_rs <= "00000000000000000000000000000011"; --Read Register 1 is value 1
	s_rt <= "10000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000011";	--Shift by 3
	s_Immediate_or_Register <= '1';				--use Register
	s_ALUSrc <= '0';							--Use Immediate
	s_ALU_CTRL <= "00111";							--Choose SLL
	
	wait for 50 ns;
	
	--SRA--
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000011";	--Shift by 3
	s_ALUSrc <= '1';							--Use Immediate
	s_ALU_CTRL <= "01000";							--Choose SLL
	
	wait for 50 ns;
	--SRAV--
	s_rs <= "00000000000000000000000000000011"; --Read Register 1 is value 3
	s_rt <= "10000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000011";	--Shift by 3
	s_Immediate_or_Register <= '1';				--use Register 1 for shifting
	s_ALUSrc <= '0';							--Use Immediate
	s_ALU_CTRL <= "01000";							--Choose SLL
	
	wait for 50 ns;
	
	--Sub Operation edge
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "11111111111111111111111111111111"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "10100";						--Choose to SUB
	wait for 50 ns;
	
	--add edge
		s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "11111111111111111111111111111111"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "00100";						--Choose to add
	wait for 50 ns;
	--ADD Operation--
	
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000010"; --Read Register 2 is value 2
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "00100";						--Choose to ADDER
	
	--Output should be 3--
	wait for 50 ns;
	
	--ADDI	Operation--
	
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000010"; --Read Register 2 is value 2
	s_imm <="00000000000000000000000000000001"; --s_imm
	s_ALUSrc <= '1';							--Take Immediate value
	s_ALU_CTRL <= "00100"; 						--Add things
	
	wait for 50 ns;
	
	
	--Sub Operation-
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "10100";						--Choose to SUB
	
	--Output Should be 1--
	wait for 50 ns;
	--OR Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "00000";						--Choose to OR
	
	--Output Should be 3 --
	
	wait for 50 ns;
	--AND Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000010"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "00010";						--Choose to AND
	--Output Should be the same--
	
	wait for 50 ns;
	--ANDI Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000001";	--immediate value
	s_ALUSrc <= '1';							--Use Registers
	s_ALU_CTRL <= "00010";						--Choose to ANDI
	
	--Output Should be 0--
	wait for 50 ns;
	--CLZ Operation--
	s_rs <= "00000000000000000000000000000010"; --30 Leading Zeros
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "01011";						--Choose to CLZ
	
	wait for 50 ns;
	--CLO Operation--
	s_rs <=  "10000000000000000000000000000010"; --1 Leading One
	s_rt <=  "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <= "00000000000000000000000000000001";--31 zeros
	s_ALUSrc <= '0';							--Add two registers together
	s_ALU_CTRL <= "01010";						--Choose to CLO
	

	wait for 50 ns;
	--NOR Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	
	s_ALUSrc <= '0';							--Use Registers
	s_ALU_CTRL <= "00001";						--Choose to NOR
	
	--Result should be 0xFFFF_FFFC--
	wait for 50 ns;
	--XOR Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	
	s_ALUSrc <= '0';							--Use Registers
	s_ALU_CTRL <= "00011";						--Choose to XOR
	
	--Result should be 0x0000_0003--
	wait for 50 ns;
	
	--XORI Operation--
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000001"; 
	s_ALUSrc <= '1';							--Immediate Value
	s_ALU_CTRL <= "00011";						--Choose to XORI
	
	--Result should be 0x0000_0003--
	wait for 50 ns;
	s_rs <= "00000000000000000000000000000010"; --Read Register 1 is value 2
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Use Registers
	s_ALU_CTRL <= "11001";						--Choose SLT
	
	--Result should be 0 because 2 is not less than 1
	wait for 50 ns;
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000010"; --Read Register 2 is value 2
	s_ALUSrc <= '0';							--Use Registers
	s_ALU_CTRL <= "11001";						--Choose SLT
	--Result should be 1 because 1 is less than 2
	
	wait for 50 ns;
	s_rs <= "00001000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_ALUSrc <= '0';							--Use Registers
	s_ALU_CTRL <= "11001";						--Choose SLT
	--Result should be 0 again because 1 is not less than 1
	wait for 50 ns;
	
	
	--SLL Operation--
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000011";	--Shift by 3
	s_ALUSrc <= '0';							--Use Register
	s_ALU_CTRL <= "00110";							--Choose SLL
	
	wait for 50 ns;
	--SLLV--
	s_rs <= "00000000000000000000000000000011"; --Read Register 1 is value 1
	s_rt <= "00000000000000000000000000000001"; --Read Register 2 is value 3
	
	s_Immediate_or_Register <= '1';				--Use Register 1 for shifting 
	s_ALUSrc <= '0';							--Use Register 2 to be shifted
	s_ALU_CTRL <= "00110";							--Choose SLL
	
	wait for 50 ns;
	--SRL--
	s_rs <= "00000000000000000000000000000001"; --Read Register 1 is value 1
	s_rt <= "10000000000000000000000000000001"; --Read Register 2 is value 1
	s_imm <="00000000000000000000000000000011";	--Shift by 3
	s_ALUSrc <= '0';							--Use Register 2 to be shifted
	s_ALU_CTRL <= "00111";							--Choose SLL
	
	wait for 50 ns;
	
	
	end process;
	
end behavior;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	