
library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;

entity selector is
    Port ( P1 : in  STD_LOGIC_VECTOR(7 downto 0);
	        P2 : in  STD_LOGIC_VECTOR(7 downto 0);
           Q : out  STD_LOGIC_VECTOR (7 downto 0);
			  sel : in  STD_LOGIC
			  );
				
end selector;

architecture Behavioral of selector is


begin

	Q <= P1 when (sel='1') else P2;

end behavioral;
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PtoS is
    Port ( x1: in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x3 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x4 : in  STD_LOGIC_VECTOR (7 downto 0);
           XOut : out  STD_LOGIC_VECTOR (7 downto 0);
           clk1 : in  STD_LOGIC;
           reset1 : in  STD_LOGIC;
           Load : in  STD_LOGIC);

end PtoS;

architecture Behavioral of PtoS is

----Component

component selector is
port ( 

		P1 : in STD_LOGIC_VECTOR(7 downto 0);
		P2 : in STD_LOGIC_VECTOR (7 downto 0);
		sel : in STD_LOGIC;
		Q : out STD_LOGIC_VECTOR(7 downto 0)
      
		);

end component;

-- declare the variable 
signal R4 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal R5 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal R6 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');

-- Map the component to the external pins
begin
out_mux : selector

	port map (
		P1 => x1,
		P2 => R6,
		sel => load,
		Q => XOut
	);
	
process(clk1,reset1,load,x4,x3,x2,R6,R5,R4)

begin 

if (reset1 = '1') then -- condtion of reset
					R6 <= (others => '0');
					R5 <= (others => '0');
					R4 <= (others => '0');
else if rising_edge(clk1) then -- wait until rising edge

			if (load = '1') then -- input the data to the registers
					R6 <= x2 ( 7 downto 0 );
					R5 <= x3 ( 7 downto 0 );
					R4 <= x4 ( 7 downto 0  );
			elsif (load ='0') then -- the condition of shifting the data to output
						R6 <= R5 ( 7 downto 0 );
						R5<= R4 ( 7 downto 0 );
						R4 <= (others => '0');
			end if;
	      end if;
			end if;


end process;

end Behavioral;
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity Mixcolumn is
    Port ( Input : in  STD_LOGIC_VECTOR (7 downto 0);
           output : out  STD_LOGIC_VECTOR(7 downto 0);
			  clk: in std_logic;
			  Decrypt: in std_logic;
			  reset: in std_logic
			  );
			  
end Mixcolumn;

architecture Behavioral of Mixcolumn is

-- enter component
component PtoS is

    Port ( x1: in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x3 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x4 : in  STD_LOGIC_VECTOR (7 downto 0);
           XOut : out  STD_LOGIC_VECTOR (7 downto 0);
           clk1 : in  STD_LOGIC;
           reset1 : in  STD_LOGIC;
           Load : in  STD_LOGIC);

end component;

-- variables declare
-- R0-R3 is the register
signal R0 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal R1 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal R2 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal R3 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
-- y1-y4 is the data of AND gate
signal y1 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal y2 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal y3 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal y4 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
-- z1-z4 is the data of XOR gate
signal z1 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal z2 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal z3 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
signal z4 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
-- clear the data of register (R0-R3)
signal en1 : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
-- shift out or input the data to "final_Output" stage
signal load2 : STD_LOGIC;
--Clock Count
signal count : integer range 0 to 4:= 0;
--Galois function
signal G2 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal G3 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal G9 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal G11 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal G13 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal G14 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
-- Byte_Input
signal Input1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

-- the funtion of Galois2
function Galo2 (Input: in  STD_LOGIC_VECTOR (7 downto 0)) return std_logic_vector is 
	--signals
	variable Galo2 : std_logic_vector(Input 'range);
	--function
	begin
		IF (Input(7) = '1') then    ---Each byte  is it's own conditin
		Galo2 :=(Input(6 downto 0) & '0') XOR X"1B";
	   ELSE
			Galo2 := Input(6 downto 0) & '0';
	   END IF;							
	return Galo2;

end function;

-- Mapping
begin

final_Output : PtoS

	port map (
		x1 => R0,
		x2 => R1,
		x3 => R2,
		x4 => R3,
		clk1 => clk ,
		reset1 => reset,
		XOut => output,
		Load => load2
	);




-- Main process
MixCol : process(clk,reset)

begin

if (reset = '1' ) then 

    R0 <= (others => '0');

	 R1 <= (others => '0');

	 R2 <= (others => '0');

	 R3 <= (others => '0');
	 
    count <= 0;
	 

else if (rising_edge (clk)) then
	 
	 	 count <= count+1;

	 en1 <= (others => '1');
    R0 <= z1;
    R1 <= z2;
    R2 <= z3;
    R3 <= z4;

	 
    load2 <= '0';
	 
	 if (count = 4) then 
	   count <= 1;
		load2 <= '1';
		en1 <= (others => '0'); 

    end if;

  end if;

 end if;


end process;

-- feedback of AND
	 y1 <= R1 and en1;
    y2 <= R2 and en1;
    y3 <= R3 and en1;
    y4 <= R0 and en1; 
	 
--Assign input
Input1<=Input;


----Decrypt Process

Decrypt_Process : process (clk,Decrypt)

begin

		if (Decrypt = '1') then 

			--assign XOR Outputs

			z1 <= G9 XOR y1;

			z2<= G13 XOR y2;

			z3 <= G11 XOR y3;

			z4 <= G14 XOR y4;

		else if (Decrypt = '0' ) then 

			--Assign XOR Outputs

			z1 <= Input1 XOR y1;

			z2 <= Input1 XOR y2;

			z3 <= G3 XOR y3;

			z4 <= G2 XOR y4;

		end if;

end if;

end process;

	 
-- each value of GF
G9   <= Galo2( Galo2( Galo2( Input1 ))) XOR Input1;
G13  <= Galo2( Galo2( Galo2( Input1 ) XOR Input1)) XOR Input1;
G11  <= Galo2( Galo2( Galo2( Input1 )) XOR Input1) XOR Input1;
G14  <= Galo2( Galo2( Galo2( Input1) XOR Input1 ) XOR Input1 );
G2 <= Galo2(Input1);
G3 <= Galo2(Input1) XOR Input1 ;
	 
end Behavioral;

