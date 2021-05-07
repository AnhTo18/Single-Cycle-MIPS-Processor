library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity regfile is
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
end regfile;

architecture structural of regfile is

component register_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;

component decoder_5to32 is
port (i_enable : in std_logic;
		i_regWrAddr : in std_logic_vector(4 downto 0);
      o_regWriteto   : out std_logic_vector(31 downto 0)); --reg write enable

end component;

component mux32t1_N is
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
 end component;

type arr is array (0 to 31) of std_logic_vector(31 downto 0);
signal s_WE    : std_logic_vector(31 downto 0);    -- write enable 
signal reg : arr;

begin

write_enable: decoder_5to32               --reg write enabling
	port map(i_enable => iWE,
			 i_regWrAddr => iWS,
			 o_regWriteto => s_WE);



 reg0:  register_N                --ISA requirement $0=0
    port map(i_CLK => CLK,
    i_RST => '1',
    i_WE => '0',
    i_D => "00000000000000000000000000000000",
    o_Q => reg(0));
			 
			 
			 
			 
registers: for i in 1 to N-1 generate --generating  register 1-31
  regi:  register_N
    port map(i_CLK => CLK,
    i_RST => RST,
    i_WE => s_WE(i),
    i_D => iWD,
    o_Q => reg(i));
	
end generate;	
rs: mux32t1_N
	port map(i_s=>iRS,            --picking rs register base on rs selector
       i_1=>reg(0),           
       i_2=>reg(1),           
       i_3 =>reg(2),     
       i_4 =>reg(3),         
       i_5 =>reg(4),          
       i_6 =>reg(5),          
       i_7 =>reg(6),          
       i_8 =>reg(7),
       i_9 =>reg(8),
       i_A  =>reg(9),
       i_B =>reg(10),
       i_C =>reg(11),
       i_D =>reg(12),
       i_E =>reg(13),
       i_F =>reg(14),
       i_10=>reg(15),
       i_11=>reg(16),
       i_12=>reg(17),
       i_13=>reg(18),
       i_14=>reg(19),
       i_15=>reg(20),
       i_16 =>reg(21),
       i_17          =>reg(22),
       i_18         =>reg(23),
       i_19        =>reg(24),
       i_1A         =>reg(25),
       i_1B        =>reg(26),
       i_1C        =>reg(27),
       i_1D          =>reg(28),
       i_1E          =>reg(29),
       i_1F          =>reg(30),
       i_20         =>reg(31),
       o_F           =>oRS);
	
	
	
rt: mux32t1_N
	port map(i_s=>iRT,             --picking rt register base on rt selector
       i_1=>reg(0),           
       i_2=>reg(1),           
       i_3 =>reg(2),     
       i_4 =>reg(3),         
       i_5 =>reg(4),          
       i_6 =>reg(5),          
       i_7 =>reg(6),          
       i_8          =>reg(7),
       i_9           =>reg(8),
       i_A           =>reg(9),
       i_B           =>reg(10),
       i_C           =>reg(11),
       i_D           =>reg(12),
       i_E           =>reg(13),
       i_F         =>reg(14),
       i_10         =>reg(15),
       i_11          =>reg(16),
       i_12         =>reg(17),
       i_13          =>reg(18),
       i_14        =>reg(19),
       i_15         =>reg(20),
       i_16         =>reg(21),
       i_17          =>reg(22),
       i_18         =>reg(23),
       i_19        =>reg(24),
       i_1A         =>reg(25),
       i_1B        =>reg(26),
       i_1C        =>reg(27),
       i_1D          =>reg(28),
       i_1E          =>reg(29),
       i_1F          =>reg(30),
       i_20         =>reg(31),
       o_F           =>oRT);


end structural;