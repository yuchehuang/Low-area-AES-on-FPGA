
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GF2_2 is
	Port(	data_GF2_2 : in STD_LOGIC_VECTOR(3 DOWNTO 0);
			output_GF2_2: out STD_LOGIC_VECTOR(1 DOWNTO 0));
end GF2_2;

architecture RTL of GF2_2 is
begin 
	output_GF2_2 <= (((data_GF2_2(3)xor data_GF2_2(2))AND(data_GF2_2(1)xor data_GF2_2(0)))xor(data_GF2_2(2)AND data_GF2_2(0)))&
						 ((data_GF2_2(3)AND data_GF2_2(1))XOR (data_GF2_2(2)AND data_GF2_2(0)));

end RTL;	
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity constant_multiplier_fi is
	Port(	data_fi: in STD_LOGIC_VECTOR(1 DOWNTO 0);
			output_fi: out STD_LOGIC_VECTOR(1 DOWNTO 0));
end constant_multiplier_fi;
architecture RTL of constant_multiplier_fi is
begin
	output_fi<= (data_fi(1)XOR data_fi(0))&
					 data_fi(1);
end RTL;
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity constant_multiplier_Lambda is 
	Port(	data_Lambda : in STD_LOGIC_VECTOR(3 DOWNTO 0);
			output_Lambda: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end constant_multiplier_Lambda;

architecture RTL of constant_multiplier_Lambda is 
begin
	output_Lambda<=(data_Lambda(2)XOR data_Lambda(0))& 
						(data_Lambda(2)XOR data_Lambda(0)XOR data_Lambda(3)XOR data_Lambda(1))& 
						 data_Lambda(3) & 
						 data_Lambda(2);  
end RTL;
---------------------------------------------------------------------------------	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity square is
	port(	data_square: in STD_LOGIC_VECTOR(3 DOWNTO 0);
			output_square: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end square;

architecture RTL of square is
begin
	output_square<= 	data_square(3)&
							(data_square(3)XOR data_square(2))&
							(data_square(2)XOR data_square(1))&
							(data_square(3)XOR data_square(1)XOR data_square(0));
end RTL;	

---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GF2_4 is
	Port(	data_GF2_4:  in STD_LOGIC_VECTOR(7 DOWNTO 0);
			output_GF2_4: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end GF2_4;
architecture RTL of GF2_4 is 

	component GF2_2  
		Port(	data_GF2_2 : in STD_LOGIC_VECTOR(3 DOWNTO 0);
				output_GF2_2: out STD_LOGIC_VECTOR(1 DOWNTO 0));
	end component;	

	component constant_multiplier_fi  
		Port(	data_fi : in STD_LOGIC_VECTOR(1 DOWNTO 0);
				output_fi: out STD_LOGIC_VECTOR(1 DOWNTO 0));
	end component ;
	
	signal High_output : std_logic_vector(1 downto 0);
	signal Mid_output : std_logic_vector(1 downto 0);
	signal Low_output : std_logic_vector(1 downto 0);
	signal High_xor_temp : std_logic_vector(1 downto 0);
	signal Low_xor_temp : std_logic_vector(1 downto 0);
	signal fi_output_temp: std_logic_vector(1 downto 0);
begin 
	High_xor_temp <= data_GF2_4(7 downto 6)XOR data_GF2_4(5 downto 4);
	Low_xor_temp <= data_GF2_4(3 downto 2)XOR data_GF2_4(1 downto 0);
	High: GF2_2 port map (data_GF2_2(3 downto 2) => data_GF2_4(7 downto 6), data_GF2_2(1 downto 0) => data_GF2_4(3 downto 2), output_GF2_2 => High_output );
	Mid: GF2_2 port map (data_GF2_2(3 downto 2) => High_xor_temp ,data_GF2_2(1 downto 0) => Low_xor_temp , output_GF2_2 => Mid_output );
	Low: GF2_2 port map (data_GF2_2(3 downto 2) => data_GF2_4(5 downto 4), data_GF2_2(1 downto 0) => data_GF2_4(1 downto 0), output_GF2_2 => Low_output);
	fi: constant_multiplier_fi port map (data_fi =>High_output, output_fi =>fi_output_temp);
	output_GF2_4 <= (Mid_output XOR Low_output) & (fi_output_temp XOR Low_output); 
end RTL; 
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_GF2_4 is
	port(	data_inv_GF2_4: in STD_LOGIC_VECTOR(3 DOWNTO 0);
			output_inv_GF2_4: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end inv_GF2_4;

architecture RTL of inv_GF2_4 is
begin
	output_inv_GF2_4<= 	(data_inv_GF2_4(3) XOR (data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(1)) Xor (data_inv_GF2_4(3) and data_inv_GF2_4(0))xor data_inv_GF2_4(2))& 
								((data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(1)) xor (data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(0)) xor (data_inv_GF2_4(3) and data_inv_GF2_4(0)) xor data_inv_GF2_4(2) xor(data_inv_GF2_4(2)and data_inv_GF2_4(1)))&
								(data_inv_GF2_4(3) xor (data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(1)) xor (data_inv_GF2_4(3) and data_inv_GF2_4(1) and data_inv_GF2_4(0))xor data_inv_GF2_4(2) xor (data_inv_GF2_4(2) and data_inv_GF2_4(0)) xor data_inv_GF2_4(1))&
								((data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(1)) xor (data_inv_GF2_4(3) and data_inv_GF2_4(2) and data_inv_GF2_4(0)) xor (data_inv_GF2_4(3)and data_inv_GF2_4(1)) xor (data_inv_GF2_4(3) and data_inv_GF2_4(1) and data_inv_GF2_4(0))xor (data_inv_GF2_4(3) and data_inv_GF2_4(0)) xor data_inv_GF2_4(2) xor (data_inv_GF2_4(2) and data_inv_GF2_4(1)) xor (data_inv_GF2_4(2) and data_inv_GF2_4(1)and data_inv_GF2_4(0)) xor data_inv_GF2_4(0)xor data_inv_GF2_4(1));
end RTL;	
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplicative_inv is
	port(	data_multi: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			output_multi: out STD_LOGIC_VECTOR(7 DOWNTO 0));
end multiplicative_inv;

architecture RTL of multiplicative_inv is

	component square
		port(	data_square: in STD_LOGIC_VECTOR(3 DOWNTO 0);
			output_square: out STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component;
	
	component constant_multiplier_Lambda 
		Port(	data_Lambda : in STD_LOGIC_VECTOR(3 DOWNTO 0);
				output_Lambda: out STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component;
	
	component inv_GF2_4 
		port(	data_inv_GF2_4: in STD_LOGIC_VECTOR(3 DOWNTO 0);
				output_inv_GF2_4: out STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component;

	component GF2_4 
		Port(	data_GF2_4:  in STD_LOGIC_VECTOR(7 DOWNTO 0);
				output_GF2_4: out STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component;
	
	signal square_output : std_logic_vector(3 downto 0);
	signal Low_xor_temp : std_logic_vector(3 downto 0);
	signal Mid_xor_temp : std_logic_vector(3 downto 0);
	signal Lambda_output : std_logic_vector(3 downto 0);
	signal inv_GF2_4_output : std_logic_vector(3 downto 0);
	signal GF2_4_output : std_logic_vector(3 downto 0);	
	
begin
	square1: square port map(data_square=>data_multi(7 downto 4),output_square=> square_output);
	Lambda: constant_multiplier_Lambda port map (data_Lambda=>square_output,output_Lambda=>Lambda_output);
	Low_xor_temp <= data_multi(7 downto 4) Xor data_multi(3 downto 0);
	GF2_4_1: GF2_4 port map (data_GF2_4(7 downto 4)=> Low_xor_temp ,data_GF2_4(3 downto 0)=> data_multi(3 downto 0) ,output_GF2_4 =>GF2_4_output );
	Mid_xor_temp <= GF2_4_output xor Lambda_output;
	inv_GF: inv_GF2_4 port map(data_inv_GF2_4=>Mid_xor_temp, output_inv_GF2_4=> inv_GF2_4_output);
	GF2_4_2: GF2_4 port map(data_GF2_4(7 downto 4)=>data_multi(7 downto 4) ,data_GF2_4(3 downto 0)=>inv_GF2_4_output ,output_GF2_4=>output_multi(7 downto 4));
	GF2_4_3: GF2_4 port map(data_GF2_4(7 downto 4)=>inv_GF2_4_output ,data_GF2_4(3 downto 0)=> Low_xor_temp ,output_GF2_4=>output_multi(3 downto 0));
end RTL;

-------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mapping  is
		Port (m_in: in STD_LOGIC_VECTOR(7 downto 0);
				mapping_output: out STD_LOGIC_VECTOR(7 downto 0));	
end mapping;

architecture RTL of mapping is 
begin 
	    mapping_output<= (m_in(7)xor m_in(5))& 
								(m_in(7)xor m_in(6) xor m_in(4) xor m_in(3) xor m_in(2) xor m_in(1))&
								(m_in(7) xor m_in(5) xor m_in(3) xor m_in(2))&
								(m_in(7) xor m_in(5) xor m_in(3) xor m_in(2) xor m_in(1))&
								(m_in(7) xor m_in(6) xor m_in(2) xor m_in(1))&
								(m_in(7) xor m_in(4) xor m_in(3) xor m_in(2) xor m_in(1))&
								(m_in(6) xor m_in(4) xor m_in(1))&
								(m_in(6) xor m_in(1) xor m_in(0));
end RTL;
----------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INV_mapping  is
		Port (inv_m_in: in STD_LOGIC_VECTOR(7 downto 0);
				inv_mapping_output: out STD_LOGIC_VECTOR(7 downto 0));	
end INV_mapping;

architecture RTL of INV_mapping is 
begin 
	    inv_mapping_output<= 	(inv_m_in(7) xor inv_m_in(6) xor inv_m_in(5) xor inv_m_in(1))&
										(inv_m_in(6) xor inv_m_in(2))&
										(inv_m_in(6) xor inv_m_in(5) xor inv_m_in(1))&
										(inv_m_in(6) xor inv_m_in(5) xor inv_m_in(4) xor inv_m_in(2) xor inv_m_in(1))&
										(inv_m_in(5) xor inv_m_in(4) xor inv_m_in(3) xor inv_m_in(2) xor inv_m_in(1))&
										(inv_m_in(7) xor inv_m_in(4) xor inv_m_in(3) xor inv_m_in(2) xor inv_m_in(1))&
										(inv_m_in(5) xor inv_m_in(4))&
										(inv_m_in(6) xor inv_m_in(5) xor inv_m_in(4) xor inv_m_in(2) xor inv_m_in(0));
end RTL;
--------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inversion_model  is
		Port (inv_in: in STD_LOGIC_VECTOR(7 downto 0);
				inv_output: out STD_LOGIC_VECTOR(7 downto 0));	
end inversion_model;

architecture RTL of inversion_model is 

 component multiplicative_inv 
	port(	data_multi: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			output_multi: out STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component INV_mapping  is
		Port (inv_m_in: in STD_LOGIC_VECTOR(7 downto 0);
				inv_mapping_output: out STD_LOGIC_VECTOR(7 downto 0));	
	end component;
	
	component mapping  is
		Port (m_in: in STD_LOGIC_VECTOR(7 downto 0);
				mapping_output: out STD_LOGIC_VECTOR(7 downto 0));	
	end component;	
	
	signal temp_mapping: STD_LOGIC_VECTOR(7 downto 0);
	signal temp_inv_mapping: STD_LOGIC_VECTOR(7 downto 0);
begin 
	 isomorphic: mapping port map(m_in=> inv_in, mapping_output=>temp_mapping);
	 multiplicative: multiplicative_inv port map(data_multi=>temp_mapping,output_multi=>temp_inv_mapping);
	 INV_mapping_model: INV_mapping port map(inv_m_in=>temp_inv_mapping,inv_mapping_output=>inv_output);	 
		 
end RTL;
----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AF is
	Port(	AF_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			AF_output: out STD_LOGIC_VECTOR(7 DOWNTO 0));
end AF;

architecture Behavioural of AF is		
	
begin

		AF_output<= ((AF_in(7) xor AF_in(6)xor AF_in(5)xor AF_in(4)xor AF_in(3))xor '0')&
						((AF_in(6) xor AF_in(5)xor AF_in(4)xor AF_in(3)xor AF_in(2))xor '1')&
						((AF_in(5) xor AF_in(4)xor AF_in(3)xor AF_in(2)xor AF_in(1))xor '1')&
						((AF_in(4) xor AF_in(3)xor AF_in(2)xor AF_in(1)xor AF_in(0))xor '0')&
						((AF_in(3) xor AF_in(2)xor AF_in(1)xor AF_in(0)xor AF_in(7))xor '0')&
						((AF_in(2) xor AF_in(1)xor AF_in(0)xor AF_in(7)xor AF_in(6))xor '0')&
						((AF_in(1) xor AF_in(0)xor AF_in(7)xor AF_in(6)xor AF_in(5))xor '1')&
						((AF_in(0) xor AF_in(7)xor AF_in(6)xor AF_in(5)xor AF_in(4))xor '1');	

end Behavioural;	
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AF_inv is
	Port(	AF_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			AF_inv_output: out STD_LOGIC_VECTOR(7 DOWNTO 0));
end AF_inv;

architecture Behavioural of AF_inv is		
begin
		AF_inv_output<= 	((AF_in(6) xor AF_in(4)xor AF_in(1))xor '0')& 
								((AF_in(5) xor AF_in(3)xor AF_in(0))xor '0')&
								((AF_in(7) xor AF_in(4)xor AF_in(2))xor '0')&
								((AF_in(6) xor AF_in(3)xor AF_in(1))xor '0')&
								((AF_in(5) xor AF_in(2)xor AF_in(0))xor '0')&
								((AF_in(7) xor AF_in(4)xor AF_in(1))xor '1')&
								((AF_in(6) xor AF_in(3)xor AF_in(0))xor '0')&
								((AF_in(7) xor AF_in(5)xor AF_in(2))xor '1');		

end Behavioural;	
----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Buffer_8_bit is
	Port(	D_in_0 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			D_in_1 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			Q_output: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			sel: in STD_LOGIC);
end Buffer_8_bit;

architecture Behavioural of Buffer_8_bit is
begin
	process(D_in_0,D_in_1, Sel) 
		begin
			if sel='0' then
				Q_output<=D_in_0;
			else 
				Q_output<=D_in_1;
			end if;	
		end process;		
end Behavioural;	
----------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SubByte is
	Port(	data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_output: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Sel: in STD_LOGIC);
end SubByte;

architecture Behavioural of SubByte is	

	component Buffer_8_bit is
		Port(	D_in_0 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
				D_in_1 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
				Q_output: out STD_LOGIC_VECTOR(7 DOWNTO 0);
				sel: in STD_LOGIC);
	end component;

	component AF_inv is
		Port(	AF_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
				AF_inv_output: out STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;

	component AF is
		Port(	AF_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
				AF_output: out STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;

	component inversion_model  is
		Port (inv_in: in STD_LOGIC_VECTOR(7 downto 0);
				inv_output: out STD_LOGIC_VECTOR(7 downto 0));	
	end component;
	
	signal step1_temp_1: STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
	signal step2_temp: STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
	signal chosen_temp: STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
	signal AT_output: STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
	signal output_temp: STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
begin
	AT_inv: AF_inv port map (AF_in=>data_in,AF_inv_output=>step1_temp_1);
	buffer_1: Buffer_8_bit port map (D_in_1=>step1_temp_1,D_in_0=>data_in,Q_output=>chosen_temp,sel=>sel); 
	multiplacation: inversion_model port map(inv_in=>chosen_temp, inv_output=>step2_temp);
	AT: AF port map (AF_in=> step2_temp, AF_output=>AT_output); 
	buffer_2: Buffer_8_bit port map (D_in_1=>step2_temp,D_in_0=>AT_output,Q_output=>data_output,sel=>sel);
end Behavioural;	
----------------------------------------------------------------
