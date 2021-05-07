

library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;


  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
component regfile is
  generic(N: integer:= 32);
  port (CLK :in std_logic;
		RST :in std_logic;
		iWE  :in std_logic;    --write enable
		iRS  :in std_logic_vector(4 downto 0);    --read register 1
		iRT  :in std_logic_vector(4 downto 0);   --read register 2
		iWS  :in std_logic_vector(4 downto 0);    -- write register select
		iWD  :in std_logic_vector(31 downto 0);		--write register data
		oRS  :out std_logic_vector(31 downto 0); 	--read data 1
		oRT  :out std_logic_vector(31 downto 0)); --read data 2
end component;

component register_NJAL is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;


component addersub_N is
generic(N : integer := 32);
port(A, B       : in std_logic_vector(N-1 downto 0);
     nAdd_Sub, Cin   : in std_logic;
     output        : out std_logic_vector(N-1 downto 0);
	 Cout        : out std_logic);
	 

end component;

component extender16t32 is 
  
  port(i  : in  std_logic_vector(15 downto 0);
       i_sign : in  std_logic;                    --'0' for zero    '1' for sign
       o: out std_logic_vector(31 downto 0));
end component;

component barrel_shifter is
   port(
	i_shamt	: in std_logic_vector(4 downto 0);		--Amount to shift
	i_data	: in std_logic_vector(31 downto 0);		--Input Data
	i_Right_Or_Left : in std_logic;					--0 is Right 1 is Left
	i_bit	: in std_logic;							--Arithmetic or Logic Shift					
	o_data	: out std_logic_vector(31 downto 0)); 	--Output Data					

end component;

component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component mux3t1_5bits is                                --for choosing write register
  generic(N : integer := 5);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
	   i_C		: in std_logic_vector(N-1 downto 0);
       i_s	    : in std_logic_vector(1 downto 0);
       o_F	   : out std_logic_vector(N-1 downto 0));

end component;

component controlUnit is
	port(opcode					: in std_logic_vector(5 downto 0);
	     functionCode			: in std_logic_vector(5 downto 0);
		 ALUSrc					: out std_logic;
		 ALUControl     		: out std_logic_vector(4 downto 0); --need alu to decide
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
end component;
 
component ALU_Final is

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
		

end component;

component mux3t1_32bits is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
	   i_C		: in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic_vector(1 downto 0);
       o_Y          : out std_logic_vector(N-1 downto 0));

end component;


--dummy signal
signal s_whatever: std_logic;
--PC signals
signal s_address, s_pcplusfour: std_logic_vector(31 downto 0);
signal s_shiftedSignEx: std_logic_vector(31 downto 0);
signal s_branchAddress: std_logic_vector(31 downto 0);
signal s_branch:std_logic; --decide whether to branch or pc+4
signal s_zero:std_logic;
signal s_BranchOrPCplusfour: std_logic_vector(31 downto 0); --result of the branch addres vs pc+4 mux

--Jump signals
signal s_fetchedJump,s_jumpShiftResult, s_jumpAddr,s_JumpOrJrResult: std_logic_vector(31 downto 0);
--16 bit offset sign extend
signal s_signEx,s_Ex: std_logic_vector(31 downto 0); --use for imm
--ALU signals
signal s_ALUsrc, s_bne, s_beq, s_jump, s_jumpReg,s_carryOut,o_zero: std_logic;
signal s_ALUControl: std_logic_vector(4 downto 0);
signal s_MemtoReg,s_RegDst: std_logic_vector(1 downto 0);
signal s_readDataOne,s_z,s_luiImm,s_Imm: std_logic_vector(31 downto 0);
signal s_logic,s_immOrReg: std_logic;
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_Address when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  s_Halt <='1' when (s_Inst(31 downto 26) = "010100")  else '0';
  
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 





--updating PC  
  PC: register_NJAL

  port map(i_CLK=>iCLK,
       i_RST=>iRST,
       i_WE=>'1',
       i_D=>s_NextInstAddr,
       o_Q =>s_address);
  
  
  
  
  PCplusfour:addersub_N
  port map(A=>s_address,
B=>x"00000004",
nAdd_Sub=>'0',
Cin=>'0',
output=>s_pcplusfour,
Cout=>s_whatever);


--Branching address calculation
signEx:extender16t32                                                        --extend 16 bit offset for value preserveration, also gonna use for ALUsrc
port map(i=>s_Inst(15 downto 0),
       i_sign=>'1',                    --'0' for zero    '1' for sign
       o=>s_signEx);


sll2:barrel_shifter                                                        --shifting sign extended value by two 
   port map(
	i_shamt=>"00010",	
	i_data=>s_signEx,	
	i_Right_Or_Left=>'1',				--0 is Right 1 is Left
	i_bit=>'1',							--Arithmetic or Logic Shift						
	o_data=>s_shiftedSignEx); 				

branchAddress:addersub_N														--adding shifted sign extended to pc+4 for final branch address
port map(A=>s_shiftedSignEx,
B=>s_pcplusfour,
nAdd_Sub=>'0',
Cin=>'0',
output=>s_branchAddress,
Cout=>s_whatever);

--signEx vs Ex
Ex:extender16t32                                                    
port map(i=>s_Inst(15 downto 0),
       i_sign=>'0',                    --'0' for zero    '1' for sign
       o=>s_Ex);
ExvsSignEX:mux2t1_N
  port map(i_S=>s_logic,
    i_D0=>s_signEx,
       i_D1=>s_Ex,
     
       o_O=>s_Imm);
--Branching check
  equality:addersub_N
  port map(A=>s_readDataOne,
B=>s_DMemData,
nAdd_Sub=>'1',
Cin=>'0',
output=>s_z,
Cout=>s_whatever);


process(s_Z)
	begin
		if s_Z = "00000000000000000000000000000000" then
		o_Zero <= '1';
		else
		o_Zero <= '0';
		end if;
	end process;


--Branch or PC+4 decision 
s_branch<=(s_bne and not o_zero) or (s_beq and  o_zero);
BranchOrPCplusfour:mux2t1_N
  port map(i_S=>s_branch,
    i_D0=>s_pcplusfour,
       i_D1=>s_branchAddress,
     
       o_O=>s_BranchOrPCplusfour);



--Jump address calculation 
 s_fetchedJump <= "000000" & s_Inst(25 downto 0);                               --needed to become 32 bits to shift

jumpshift:barrel_shifter                                                        --multiply 26 fetched bits by 4 through shifting
   port map(
	i_shamt=>"00010",	
	i_data=>s_fetchedJump,	
	i_Right_Or_Left=>'1',				--0 is Right 1 is Left
	i_bit=>'1',							--Arithmetic or Logic Shift						
	o_data=>s_jumpShiftResult); 

s_jumpAddr<=s_pcplusfour(31 downto 28) & s_jumpShiftResult(27 downto 0);                   --replacing lower 28 bits with fetched 26 bits shifted left by 2

--Jump or Jump register
JumpOrJr:mux2t1_N
  port map(i_S=>s_jumpReg,--need to add
     
       i_D0=>s_jumpAddr,
	     i_D1=>s_readDataOne,
       o_O=>s_JumpOrJrResult);

--NextInstAddress
NextInstAddress:mux2t1_N
  port map(i_S=>s_jump,         --deciding whether to jump or use the result of pc+4 vs branch address  as the next instruction address with jump as a selector
       i_D0=>s_BranchOrPCplusfour,
       i_D1=>s_JumpOrJrResult,
       o_O=>s_NextInstAddr);



--ALU
ALU:ALU_Final
	port map(i_A=>s_readDataOne,			--Read Register 1
		 i_B=>s_DMemData,				--Read Register 2
		 i_ALUSrc=>s_ALUsrc,							--ALU Source (Read Register 2 or Immediate)
		 i_ALUControl=>s_ALUControl,	--Chooses what operation to do from the ALU
		  i_Immediate_or_Register=>s_immOrReg,
		 i_immediate=>s_Imm,		--Immediate Value 
		 o_ALU_Result=>s_DMemAddr,	--Output of the ALU
		 o_Cout=>s_carryOut,
		 o_Zero=>s_zero);		

oALUOut<=s_DMemAddr; 

--Regfile signals                   need to add to signals
 registerFile:regfile
  port map(CLK=>iCLK,
		RST=>iRST,
		iWE=>s_RegWr,  --write enable
		iRS=>s_Inst(25 downto 21),    --read register 1
		iRT=>s_Inst(20 downto 16),   --read register 2
		iWS=>s_regWrAddr,   -- write register select
		iWD=>s_regWrData,		--write register data
		oRS=>s_readDataOne, 	--read data 1
		oRT=>s_DMemData); --read data 2


--Mem to reg mux with jal
memToReg: mux3t1_32bits           --extra value(pc+4) to support jal
	port map(i_A => s_DMemOut,
		   i_B => s_DMemAddr,
		   i_C=>s_pcplusfour,
		   i_X => s_MemtoReg, 
		   o_Y => s_regWrData);

--Register destination decision between rd, rt or reg31 for Jal
regWrAddrSelect: mux3t1_5bits
    port map(i_A => s_Inst(20 downto 16), --rt
		   i_B => s_Inst(15 downto 11),   --rd
		   i_C=> "11111",
		   i_s => s_RegDst,
		   o_F => s_regWrAddr);
		   

--Control Unit
control:controlUnit
	port map(opcode=>s_Inst(31 downto 26),
	     functionCode=>s_Inst(5 downto 0),
		 ALUSrc=>s_ALUsrc,
		 ALUControl=>s_ALUControl,
		 MemtoReg=>s_MemtoReg,
		 MemWrite=>s_DMemWr,
		 RegWrite=>s_RegWr,
		 RegDst=>s_RegDst,
		 jump=>s_jump,
		 jr=>s_jumpReg,
		 bne=>s_bne,
		 beq=>s_beq,
		 logic=>s_logic,
		 shiftbyReg=>s_immOrReg);

end structure;
