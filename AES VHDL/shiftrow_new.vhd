library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity router_sel is
port (
    data_0: in STD_LOGIC_VECTOR(7 downto 0);
	 data_1: in STD_LOGIC_VECTOR(7 downto 0);
	 sel: in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0));
end router_sel;
architecture Behavioral of router_sel is
begin
 Q <= data_0 when (sel = '0') else data_1;
end Behavioral;	
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity delay_32 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
	 clk: in STD_LOGIC;
	 reset: in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0));
end delay_32;
architecture Behavioral of delay_32 is
	signal temp: STD_LOGIC_VECTOR(263 downto 0):=(others=>'0');
begin
	
	process(clk,reset,Data)
	begin 
		if reset='1' then
			Q<=(others=>'0');
			temp<=(others=>'0');
			
		elsif rising_edge(clk) then
				Q<=temp(263 downto 256);
				temp<=temp(255 downto 0)&Data;
		end if;	
		
	end process;
end Behavioral;	
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity delay_3 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end delay_3;
architecture Behavioral of delay_3 is
 signal Temp: STD_LOGIC_VECTOR(23 downto 0):=(others=>'0'); 
begin


 Q15_output: process(reset,CLK)  
 begin
		if reset='1' then
			Temp<=(others=>'0');
			Q<=Temp(23 downto 16);
		else
			if rising_edge(CLK) then
			Q<=Temp(23 downto 16);
		   Temp<= Temp(15 downto 0)&Data;
			end if;
		end if;	

	end process;
end Behavioral;	

---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity delay_8 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end delay_8;
architecture Behavioral of delay_8 is
 signal Temp: STD_LOGIC_VECTOR(87 downto 0):=(others=>'0'); 
begin


 Q15_output: process(reset,CLK )  
 begin
		if reset='1' then
			Temp<=(others=>'0');
			Q<=Temp(87 downto 80);
		else
			if rising_edge(CLK) then
			Q<=Temp(87 downto 80 );
		   Temp<= Temp(79 downto 0)&Data;
			end if;
		end if;	

	end process;
end Behavioral;	

---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity delay_4 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end delay_4;
architecture Behavioral of delay_4 is
 signal Temp: STD_LOGIC_VECTOR(23 downto 0):=(others=>'0'); 
begin


 Q15_output: process(reset,CLK) 
 begin
		if reset='1' then
			Temp<=(others=>'0');
			Q<=Temp(23 downto 16);
		else
			if rising_edge(CLK) then
			Q<=Temp(23 downto 16);
		   Temp<= Temp(15 downto 0)&Data;
			end if;
		end if;	

	end process;
end Behavioral;	

-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity delay is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end delay;
architecture Behavioral of delay is
 signal Temp: STD_LOGIC_VECTOR(7 downto 0):=(others=>'0'); 
begin


 Q15_output: process(reset,CLK) 
 begin
		if reset='1' then
			Temp<=(others=>'0');
			Q<=Temp;
		else
			if rising_edge(CLK) then
			Q<=Temp;
		   Temp<= Data;
			end if;
		end if;	
		 
	end process;
end Behavioral;	
	
----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SR_MULTIPLEXER is
port (
    Data0: in STD_LOGIC_VECTOR(7 downto 0);
  Data1 : in STD_LOGIC_VECTOR (7 downto 0);
  selector : in STD_LOGIC;
  Q : out STD_LOGIC_VECTOR(7 downto 0)
  );
end SR_MULTIPLEXER;
architecture Behavioral of SR_MULTIPLEXER is
begin
 Q <= Data0 when (selector = '0') else Data1;
end Behavioral;


----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity SRL16X8 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
	 A3A2: in STD_LOGIC_VECTOR(1 downto 0);
    CLK : in STD_LOGIC;
    Q15 : out STD_LOGIC_VECTOR(7 downto 0);
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end SRL16X8;
architecture Behavioral of SRL16X8 is
 signal Temp: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0'); 
begin

 
 Q15_output: process(reset,CLK) 
 begin
	if reset='1' then
			Temp<=(others=>'0');
			Q15<= Temp(127 downto 120);
	else
		if rising_edge(CLK) then
		Q15<= Temp(127 downto 120);
		Temp<= Temp(119 downto 0)&Data;
		end if;
	end if;	
  
 end process; 
 
 
 Q_output: process(A3A2,Temp)
		begin
          case A3A2 is
              when "00" =>  Q <= Temp(31 downto 24);
              when "01" =>  Q <= Temp(63 downto 56);
              when "10" =>  Q <= Temp(95 downto 88);
              when "11" =>  Q <= Temp(127 downto 120);
              when others => null;
          end case;
   end process;
end behavioral;	
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity SRL16X8_1 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
	 A3A2: in STD_LOGIC_VECTOR(1 downto 0);
    CLK : in STD_LOGIC;
    Q15 : out STD_LOGIC_VECTOR(7 downto 0);
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end SRL16X8_1;
architecture Behavioral of SRL16X8_1 is
 signal Temp: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0'); 
begin

 
 Q15_output: process(reset,CLK) 
 begin
	if reset='1' then
			Temp<=(others=>'0');
			Q15<= Temp(127 downto 120);
	else
		if rising_edge(CLK) then
		Temp<= Temp(119 downto 0)&Data;
		Q15<= Temp(127 downto 120);
		
		end if;
	end if;	
  
 end process; 
 
 
 Q_output: process(A3A2,Temp)
		begin
          case A3A2 is
              when "00" =>  Q <= Temp(23 downto 16);
              when "01" =>  Q <= Temp(55 downto 48);
              when others => null;
          end case;
   end process;
end behavioral;	
-----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity shiftrow_new is
Port ( 	  Input_data :  in  STD_LOGIC_VECTOR(7 downto 0);          --Declaration IC ports
           Output_data : out  STD_LOGIC_VECTOR(7 downto 0);
			  Decrypt : in STD_LOGIC;
           Clk : in  STD_LOGIC;
			  Reset : in STD_LOGIC);
end shiftrow_new;

architecture Behavioral of shiftrow_new is

component delay is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;

component SR_MULTIPLEXER is
port (
    Data0: in STD_LOGIC_VECTOR(7 downto 0);
	Data1 : in STD_LOGIC_VECTOR (7 downto 0);
	selector : in STD_LOGIC;
	Q : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;

component SRL16X8 is
port (
		Data: in STD_LOGIC_VECTOR(7 downto 0);
		A3A2: in STD_LOGIC_VECTOR(1 downto 0);
		CLK : in STD_LOGIC;
		Q15 : out STD_LOGIC_VECTOR(7 downto 0);
		Q : out STD_LOGIC_VECTOR(7 downto 0);
		reset : in STD_LOGIC
		);	
end component;

component SRL16X8_1 is
port (
		Data: in STD_LOGIC_VECTOR(7 downto 0);
		A3A2: in STD_LOGIC_VECTOR(1 downto 0);
		CLK : in STD_LOGIC;
		Q15 : out STD_LOGIC_VECTOR(7 downto 0);
		Q : out STD_LOGIC_VECTOR(7 downto 0);
		reset : in STD_LOGIC
		);	
end component;

	signal srl_1_15_out: STD_LOGIC_VECTOR(7 downto 0);
	signal srl_1_Q_out: STD_LOGIC_VECTOR(7 downto 0);
	signal srl_2_Q_out: STD_LOGIC_VECTOR(7 downto 0);
	signal decision_1: STD_LOGIC_VECTOR(7 downto 0);
	signal A5A4A3A2 : STD_LOGIC_VECTOR(3 downto 0);

begin
	srl_1: SRL16X8 port map(Data=>Input_data,A3A2=>A5A4A3A2(1 downto 0),CLK=>CLK,Q15=>srl_1_15_out,Q=>srl_1_Q_out,reset=>reset);
	srl_2: SRL16X8_1 port map(Data=>srl_1_15_out,A3A2=>A5A4A3A2(1 downto 0),CLK=>CLK,Q=>srl_2_Q_out,reset=>reset );
	MUX_1: SR_MULTIPLEXER port map(Data0=>srl_1_Q_out,Data1=>srl_2_Q_out,selector=>A5A4A3A2(2),Q=>decision_1);
	MUX_2: SR_MULTIPLEXER port map(Data0=>decision_1,Data1=>Input_data,selector=>A5A4A3A2(3),Q=>Output_data);
process(Reset,Decrypt,CLK,A5A4A3A2)
	variable counter : integer :=0;
	
	begin
		if reset='1' then 
			counter:=0;
		else 
			if rising_edge(CLK) then

				if (counter mod 2)=0 then 
					A5A4A3A2(0)<='0';
				else
					A5A4A3A2(0)<='1';
				end if;
				
				if Decrypt='0' then
					if  ((counter mod 4=0) or(counter mod 4=3)) then
						A5A4A3A2(1)<='1';
					else
						A5A4A3A2(1)<='0';
					end if;
				else
					if  ((counter mod 4=0) or(counter mod 4=1)) then
						A5A4A3A2(1)<='1';
					else
						A5A4A3A2(1)<='0';
					end if;
				end if;
				 
				if Decrypt='0' then  
					if (counter=6 or counter=9 or counter=10) then
						A5A4A3A2(2)<='1';
					else
						A5A4A3A2(2)<='0';
					end if;
				else
					if ((counter=6) or (counter=10) or (counter=11)) then
						A5A4A3A2(2)<='1';
					else
						A5A4A3A2(2)<='0';
					end if;
				end if;	
				 
				if Decrypt='0' then 
					if counter=15 then 
						A5A4A3A2(3)<='1';
					else
						A5A4A3A2(3)<='0';
					end if; 
				else
					if counter=13 then 
						A5A4A3A2(3)<='1';
					else
						A5A4A3A2(3)<='0';
					end if;
				end if;
				counter:= counter+1;
				if counter >15 then
					counter:=0;
				end if;	
			
			end if;
		end if;	
end process;
end Behavioral;

