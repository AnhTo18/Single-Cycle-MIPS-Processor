library IEEE;
use IEEE.std_logic_1164.all;
entity mux2t1 is 
port(	i_A  : in std_logic; 
	i_B  : in std_logic; 
	i_C  : in std_logic; 
	o_F  : out std_logic); 

end mux2t1; 

architecture structure of mux2t1 is

    component andg2
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);

    end component;

    component invg
      port(i_A          : in std_logic;
           o_F          : out std_logic);

    end component;

    component org2
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);

    end component;
    
 signal s_A, s_B,s_C: std_logic; 

begin

    g_not: invg
        port MAP(i_A => i_C,
                 o_F => s_C);


    g_and_i: andg2
        port MAP(i_A => i_A,
                i_B => s_C,
                o_F => s_A);


    g_and2: andg2
        port MAP(i_A => i_C,
                i_B => i_B,
                o_F => s_B);


    g_or: org2
        port MAP(i_A => s_A,
                i_B => s_B,
                o_F => o_F);


end structure;