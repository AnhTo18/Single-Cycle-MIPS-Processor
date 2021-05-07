library IEEE;
use IEEE.std_logic_1164.all;


entity ALU_Final is

	generic(N: integer:= 32);
	port(i_A : in std_logic_vector(N-1 downto 0);				--Read Register 1
		 i_B : in std_logic_vector(N-1 downto 0);				--Read Register 2
		 i_ALUSrc : in std_logic;								--ALU Source (Read Register 2 or Immediate)
		 i_ALUControl : in std_logic_vector(4 downto 0);		--Chooses what operation to do from the ALU
		 i_Immediate_or_Register : in std_logic;
		 i_immediate : in std_logic_vector(N-1 downto 0);		--Immediate Value 
		 o_ALU_Result : out std_logic_vector(N-1 downto 0);		--Output of the ALU
		 o_Cout : out std_logic;
		 o_Zero : out std_logic);		
		

end ALU_Final;

architecture structure of ALU_Final is

---AND Gate--
component andg2
	port(i_A : in std_logic;
		 i_B : in std_logic;
		 o_F : out std_logic);
end component;
--Or Gate--
component org2
	port(i_A : in std_logic;
		 i_B : in std_logic;
		 o_F : out std_logic);
end component;
--NOR Gate--
component norg2
	port(i_A : in std_logic;
		 i_B : in std_logic;
		 o_F : out std_logic);
end component;
--XOR Gate--
component xorg2
	port(i_A : in std_logic;
		 i_B : in std_logic;
		 o_F : out std_logic);
end component;

--Barrel Shifter--
component barrel_shifterNEW
	port(i_shamt : in std_logic_vector(4 downto 0);
		 i_data : in std_logic_vector(31 downto 0);
		 i_variable_shift : in std_logic_vector(31 downto 0);
		 i_Immediate_or_Register : in std_logic;
		 i_Right_Or_Left : in std_logic;
		 i_bit : in std_logic;
		 o_data: out std_logic_vector(31 downto 0));
end component;

--	Adder    ---
component adder_Nbit
	port(i_A  :  in std_logic_vector(31 downto 0);
		 i_B  :  in std_logic_vector(31 downto 0);
		 i_Cin  :  in std_logic;
		 o_S  : out std_logic_vector(31 downto 0);
		 o_Cout  : out std_logic);
end component;
--One's COMPLEMENTOR--
component ones_complementor
	port(i_A : in std_logic_vector(31 downto 0);
		 o_F : out std_logic_vector(31 downto 0));
end component;
--2 to 1 multiplexor--
component mux2t1_Nbit
  port(i_A  : in std_logic_vector(31 downto 0);
       i_B  : in std_logic_vector(31 downto 0);
       i_Select : in std_logic;
       o_F  : out std_logic_vector(31 downto 0));

end component;
--11-1 MUX For ALU Unit--
component MUX12_1_5bitSelect
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
end component;
--Counting Leading Ones--
component clo

	port(
	i_rs : in std_logic_vector(31 downto 0);	--Data being Read in from rs
	o_rd : out std_logic_vector(31 downto 0));	--Amount of 1s

end component;
--Coutning Leading Zeros--
component clz

	port(
	i_rs : in std_logic_vector(31 downto 0);	--Data being Read in from rs
	o_rd : out std_logic_vector(31 downto 0));	--Amount of 1s

end component;


signal s_Variable : std_logic_vector(4 downto 0);
signal s_BNegation : std_logic_vector(31 downto 0);
signal s_Mux_NBit : std_logic_vector(31 downto 0);
signal s_Mux_NBit2 : std_logic_vector(31 downto 0);
signal s_Adder_Sub : std_logic_vector(31 downto 0);

signal s_and_32 : std_logic_vector(31 downto 0);
signal s_or_32 : std_logic_vector(31 downto 0);
signal s_nor_32 : std_logic_vector(31 downto 0);
signal s_xor_32 : std_logic_vector(31 downto 0);
signal s_Less : std_logic_vector(31 downto 0);
signal s_shift_left_logic : std_logic_vector(31 downto 0);
signal s_shift_right_logic : std_logic_vector(31 downto 0);
signal s_shift_right_ari : std_logic_vector(31 downto 0);
signal s_clo : std_logic_vector(31 downto 0);
signal s_clz : std_logic_vector(31 downto 0);
signal s_shamt	: std_logic_vector(4 downto 0);
signal s_Zero : std_logic_vector(31 downto 0);
signal s_Cout : std_logic;
signal s_lui,s_a : std_logic_vector(31 downto 0);

begin


-----------------------------------------Adder-Sub Portion------------------------------
--N BIT 2-1 MUX Takes the Register or takes the Immediate--

	multi_N2 : mux2t1_Nbit

	port map(i_A => i_B,				--0 takes rt
			 i_B => i_immediate,		--1 takes immediate
			 i_Select => i_ALUSrc,
			 o_F => s_Mux_NBit2);
  
--ONES COMPLEMENTOR		Complements the result for the previous MUX (Only Important for Subtraction) --

	one_comp : ones_complementor
	port map(i_A => s_Mux_NBit2,
		 o_F => s_BNegation);


--N BIT 2-1 MUX Chooses between the Negation and the Regular version of the MUX (To add or Subtract)--

	multi_N : mux2t1_Nbit

	port map(i_A => s_Mux_NBit2,
			 i_B => s_BNegation,
			 i_Select => i_ALUControl(4),
			 o_F => s_Mux_NBit);



--FIRST ADDER--
	adder : adder_Nbit
	port map(i_A => i_A,
			 i_B => s_Mux_NBit,
			 i_Cin => i_ALUControl(4),
			 o_S => s_Adder_Sub,
			 o_Cout => o_Cout);
			 
--Subtractor to check for Equality

	sub : adder_Nbit
	port map(i_A => i_A,
			 i_B => s_Mux_NBit,
			 i_Cin => '1',
			 o_S =>  s_Zero,
			 o_Cout => s_Cout);
			 
	process(s_Zero)
	begin
		if s_Zero = "00000000000000000000000000000000" then
		o_Zero <= '1';
		else
		o_Zero <= '0';
		end if;
	end process;
-----------------------------------------------------------------------------------------------			 
-----------------------------------32 bit ANDG-----------------------------------------------

	and1 : for i in 0 to 31 generate
		andg : andg2 port map
		(i_A => i_A(i),
		i_B => s_Mux_NBit(i),
		o_F => s_and_32(i));
	end generate;

--------------------------------------------------------------------------------------------------
-----------------------------------32 bit ORG ----------------------------------------------------

	or1 : for i in 0 to 31 generate
		org : org2 port map
		(i_A => i_A(i),
		i_B => s_Mux_NBit(i),
		O_F => s_or_32(i));
	end generate;
--------------------------------------------------------------------------------------------------
----------------------------------32 bit NORG----------------------------------------------------
	nor1 : for i in 0 to 31 generate
		norg : norg2 port map
		(i_A => i_A(i),
		i_B => s_Mux_NBit(i),
		O_F => s_nor_32(i));
	end generate;		 
--------------------------------------------------------------------------------------------------
----------------------------------32 bit XORG----------------------------------------------------
	xor1 : for i in 0 to 31 generate
		xorg : xorg2 port map
		(i_A => i_A(i),
		i_B => s_Mux_NBit(i),
		O_F => s_xor_32(i));
	end generate;					 
--------------------------------------------------------------------------------------------------
-------------------------------------SLT----------------------------------------------------------	
	slt : for i in 1 to 31 generate
		s_Less(i) <= '0';
	end generate;
	
	process(s_Adder_Sub, s_Less)
	begin
		if s_Adder_Sub(31) = '0' or s_Adder_Sub = "00000000000000000000000000000000" then
			s_Less(0) <= '0';
		else
			s_Less(0) <= '1';
		end if;
	end process;
			 
----------------------------------------------------------------------------------------------------
-----------------------------------SLL--------------------------------------------------------------
		
	s_shamt <= i_immediate(10 downto 6);		--Shift Amount will be Stored in the Immediate (lower 5 bits)
	
	
	shift_left_logic : barrel_shifterNEW
	port map(i_shamt => s_shamt,			--Shift Amount will be Stored in the Immediate (lower 5 bits)
			 i_data => s_Mux_NBit,			--Takes the value of rt (Read Register 2)
			 i_variable_shift => i_A,
			 i_Right_Or_Left => '1',
			 i_Immediate_or_Register => i_Immediate_or_Register,
			 i_bit =>  '0' ,
			 o_data => s_shift_left_logic);
---------------------------------------------SRL----------------------------------------------
	shift_right_logic : barrel_shifterNEW
	port map(i_shamt => s_shamt,			--Shift Amount will be Stored in the Immediate (lower 5 bits)
			 i_data => s_Mux_NBit,			--Takes the value of rt (Read Register 2)
			 i_Right_Or_Left => '0',
			 i_bit => '0',
			 i_variable_shift => i_A,
			 i_Immediate_or_Register => i_Immediate_or_Register,
			 o_data => s_shift_right_logic);
-----------------------------------------------SRA-------------------------------------------------	
	shift_right_arithmetic : barrel_shifterNEW
	port map(i_shamt => s_shamt,			--Shift Amount will be Stored in the Immediate (lower 5 bits)
			 i_data => s_Mux_NBit,			--Takes the value of rt (Read Register 2)
			 i_Right_Or_Left => '0',
			 i_bit => '1',
			 i_variable_shift => i_A,
			 i_Immediate_or_Register => i_Immediate_or_Register,
			 o_data => s_shift_right_ari);
----------------------------------------------------------------------------------------------------
-----------------------------------------Count Leading Ones---------------------------------------
	clo1 : clo
	port map(
	i_rs => i_A,			--Takes the value of rs
	o_rd => s_clo);			--Data being sent out
-----------------------------------------------------------------------------------------------------
----------------------------------------Count Leading Zeros------------------------------------------
	clz1: clz
	port map(
	i_rs => i_A,		--Takes the value of rs
	o_rd => s_clz);			--Data being sent out 
-----------------------------------------------------------------------------------------------------
----------------------------------------11 to 1 Mux Selecting and putting together everything----------
	
s_a<="00000000000000000000000000000000";
	lui : for i in 0 to 15 generate
	s_lui(i) <= s_a(i);
	end generate;
	lui1: for i in 16 to 31 generate
	s_lui(i) <= i_immediate(i-16);
	end generate;

	mux : MUX12_1_5bitSelect
	port map(
	i_OR => s_or_32,
	i_NOR => s_nor_32,
	i_AND => s_and_32,
	i_XOR => s_xor_32,
	i_ADDER => s_Adder_Sub,
	i_SUB => s_Adder_Sub,
	i_SLL => s_shift_left_logic,
	i_SRL => s_shift_right_logic,
	i_SRA => s_shift_right_ari,
	i_SLT => s_Less,
	i_CLO => s_clo,
	i_CLZ => s_clz,
	i_LUI => s_lui,
	
	i_OPERATION => i_ALUControl,
	o_RESULT => o_ALU_Result);
	
----------------------------------------------------------------------------------------------------
	
	



	

end structure;
