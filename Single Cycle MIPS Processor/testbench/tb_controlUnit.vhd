library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlUnit is
end tb_controlUnit;
architecture behavior of tb_controlUnit is
component controlUnit is
	port(opcode					: in std_logic_vector(5 downto 0);
	     functionCode			: in std_logic_vector(5 downto 0); 
		 ALUSrc					: out std_logic;
		 ALUControl     		: out std_logic_vector(3 downto 0); --need alu to decide
		 MemtoReg				: out std_logic;
		 MemWrite				: out std_logic;
		 RegWrite				: out std_logic;
		 RegDst					: out std_logic_vector(1 downto 0);
		 jump					: out std_logic;
		 jr						: out std_logic;
		 branch 				: out std_logic);
end component;

signal s_regDst: std_logic_vector(1 downto 0);
signal s_opcode, s_Funct: std_logic_vector(5 downto 0);
signal s_ALUSrc, s_MemtoReg, s_MemRd, s_memWr, s_regWr, s_jump, s_jr,s_branch: std_logic;
signal s_ALUControl: std_logic_vector(3 downto 0);
begin
	test: controlUnit 
	port map(opcode=>s_opcode,
	     functionCode=>s_Funct,
		 ALUSrc=>s_ALUSrc,
		 ALUControl=>s_ALUControl,
		 MemtoReg=>s_MemtoReg,
		 MemWrite=>s_memWr,
		 RegWrite=>s_regWr,
		 RegDst=>s_regDst,
		 jump=>s_jump,
		 jr=>s_jr,
		 branch=>s_branch);
	P_CU: process
	begin
		s_opcode<="001000"; --addi
		wait for 100 ns;
		
		s_opcode<="000000"; --add
		s_Funct <="100000";
		wait for 100 ns;
		
		s_opcode<="001001";  --addiu
		wait for 100 ns;
		
		
		s_opcode<="000000"; --and
		s_Funct <="100100";
		wait for 100 ns;
		
		s_opcode<="001100"; --andi
		wait for 100 ns;
		
		
		s_opcode<="001111"; --lui
		wait for 100 ns;
		
		
		s_opcode<="100011"; --lw
		wait for  100 ns;
		
		
		s_opcode<="000000"; --nor
		s_Funct <="100111";
		wait for 100 ns;
		
		
		s_opcode<="000000"; --xor
		s_Funct <="100110";
		wait for 100 ns;
		
		s_opcode<="001110"; --xori
		wait for 100 ns;
		
		s_opcode<="000000"; --or
		s_Funct <="100101";
		wait for 100 ns;
		
		s_opcode<="001101"; --ori
		wait for 100 ns;
		
		s_opcode<="000000"; --slt
		s_Funct <="101010";
		wait for 100 ns;
		
		s_opcode<="001010"; --slti
		wait for 100 ns;
		
		
		s_opcode<="001011"; --sltiu
		wait for 100 ns;
		
		
		s_opcode<="000000"; --sltu
		s_Funct <="101011";
		wait for 100 ns;
		
		
		s_opcode<="000000"; --sll
		s_Funct <="000000";
		wait for 100 ns;
		
		s_opcode<="000000"; --srl
		s_Funct <="000010";
		wait for 100 ns;
		
		
		s_opcode<="000000"; --sra
		s_Funct <="000011";
		wait for 100 ns;
		
		s_opcode<="101011"; --sw
		wait for 100 ns;
		
		s_opcode<="000000"; --subu
		s_Funct <="100011";
		wait for 100 ns;
		
		s_opcode<="000100"; --beq
		wait for 100 ns;
		
		s_opcode<="000101"; --bne
		wait for 100 ns;
		
		s_opcode<="000010"; --jump
		wait for 100 ns;
		
		s_opcode<="000011"; --jal
		wait for 100 ns;
		
		s_opcode<="000000"; --jump register
		s_Funct<="001000";
		wait for 100 ns;
		
		s_opcode<="011100"; --clo
		s_Funct<="100001";
		wait for 100 ns;
		
		s_opcode<="011100"; --clz
		s_Funct<="100000";
		wait for 100 ns;
		
		
		
		
	end process;
end behavior;