library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
entity controlUnit is
	port(opcode					: in std_logic_vector(5 downto 0);
	     functionCode			: in std_logic_vector(5 downto 0);
		 ALUSrc					: out std_logic;
		 ALUControl     		: out std_logic_vector(4 downto 0);
		 MemtoReg				: out std_logic_vector(1 downto 0);
		 MemWrite				: out std_logic;
		 RegWrite				: out std_logic;
		 RegDst					: out std_logic_vector(1 downto 0);
		 jump					: out std_logic;
		 jr						: out std_logic;
		 bne					: out std_logic;
		 beq					: out std_logic;
		 logic					: out std_logic;
		 shiftbyReg				: out std_logic);
end controlUnit;
architecture dataflow of controlUnit is
begin
	ALUSrc <='0' when (opcode="000000" or opcode="000100" or opcode="000101" or opcode="011100" or opcode="011100") else      --don't use imm for r format and branching
			'1';
	with opcode select
		MemtoReg<="01" when "100011",  --memtoreg only for lw
			"11" when "000011", --for jal
			"00" when others;
	with opcode select
		MemWrite<='1' when "101011", --memwrite only for sw
			'0' when others;
	RegWrite <='0' when ( (opcode="000010") or (opcode="101011") or (opcode="XXXXXX") or ((opcode="000000") and (functionCode="001000")) or (opcode="000100")or (opcode="000101")or ((opcode="000000") and (functionCode="001000"))) else --don't regwrite for j,jr,beq,bne,sw
			'1';

	with opcode select                    --need 3 to 1 mux for write register
		RegDst<="11" when "000011", --write to reg 31 when jal
				"01" when "000000",     --write to rd when r format
				"01" when "011100",
				"00" when others;  -- write to rt when everything else


	jump <='1' when ((opcode="000011")or (opcode="000010") or ((opcode="000000") and functionCode="001000")) else			--jump for j, jal, jr
			'0';
	jr <='1' when (opcode="000000" and functionCode="001000") else			--jr signal
			'0';
	with opcode select
		beq<='1' when "000100",
		'0' when others;
	with opcode select
		bne<='1' when "000101",
		'0' when others;
	logic<='1' when (opcode="001101" or opcode="001100" or opcode="001110") else
		'0';
	shiftByReg<='1' when (opcode="000000" and (functionCode="000100" or functionCode="000111" or functionCode="000110")) else
		'0';

	ALUControl<="00000" when ((opcode="000000" and functionCode="100101") or opcode="001101") else                                                                                                    --or, ori
				"00001" when (opcode="000000") and (functionCode="100111") else						           																				  --nor
				"00010" when ((opcode="000000" and functionCode="100100") or opcode="001100") else                      																					  --and,andi
				"00011" when ((opcode="000000" and functionCode="100110") or opcode="001110") else																									  --xor, xori
				"00100" when ((opcode="001000") or ((opcode="000000") and (functionCode ="100000" or functionCode ="100001")) or (opcode= "001001") or (opcode="100011") or (opcode="101011")) else   --add,addi, addiu,addu, lw, sw
				"10100" when (opcode="000000" and (functionCode="100010" or functionCode="100011"))else																								  --sub,subu
				"00110" when ((opcode="000000" and (functionCode ="000000" or functionCode ="000100"))) else																						  --sll,sllv
				"00111" when (opcode="000000" and (functionCode="000010" or functionCode ="000110")) else																							  --srl,srlv
				"01000" when  (opcode="000000" and (functionCode="000011" or functionCode="000111")) else																							  --sra,srav
				"11001" when ((opcode="000000" and (functionCode ="101010" or functionCode ="101011")) or opcode="001010" or opcode="001011") else						                              --slt, slti, sltiu, sltu
				"01010" when (opcode="011100" and functionCode="100001") else																														  --clo
				"01011" when (opcode="011100" and functionCode="100000") else 																														  --clz
				"11111" when opcode="001111" else
				"XXXXX";
end dataflow;
