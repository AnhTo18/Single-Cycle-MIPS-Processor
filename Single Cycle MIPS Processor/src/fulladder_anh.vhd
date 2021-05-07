library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_anh  is 
    port(a,b,cin  : in std_logic;
			sum,cout: out std_logic);
end fulladder_anh;
architecture structure of fulladder_anh is
component xorg2
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);

    end component;
component andg2
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);

    end component;	
	component org2
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);

    end component;	
signal s_A,s_B,s_C,s_D,s_E: std_logic;
begin
	AxorB: xorg2
        port MAP(i_A => a,
                i_B => b,
                o_F => s_A);
	AxorBxorCin: xorg2
        port MAP(i_A => s_A,
                i_B => cin,
                o_F => sum);			



AandB: andg2
        port MAP(i_A => a,
                i_B => b,
                o_F => s_B);	
AandCin: andg2
        port MAP(i_A => a,
                i_B => cin,
                o_F => s_C);
CinandB: andg2
        port MAP(i_A => b,
                i_B => cin,
                o_F => s_D);




AandBorCinandA: org2
        port MAP(i_A => s_B,
                i_B => s_C,
                o_F => s_E);	
AandBorCinandAorCinandB: org2
        port MAP(i_A => s_E,
                i_B => s_D,
                o_F => cout);					
end structure; 
