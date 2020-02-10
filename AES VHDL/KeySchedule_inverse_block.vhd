----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:56 03/19/2019 
-- Design Name: 
-- Module Name:    KeySchedule_inverse_block - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KeySchedule_inverse_block is
Port ( 	  key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
-----------------------------------------------------------------------------------------			  
--			  key_out_1 : out  STD_LOGIC_VECTOR (7 downto 0);
--			  key_out_2 : out  STD_LOGIC_VECTOR (7 downto 0);
----------------------------------------------------------------------------------------			  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end KeySchedule_inverse_block;

architecture Behavioral of KeySchedule_inverse_block is
	component MUX2 is
	 Port ( input_up : in  STD_LOGIC_VECTOR (7 downto 0);
           input_below : in  STD_LOGIC_VECTOR (7 downto 0);
           output_data : out  STD_LOGIC_VECTOR (7 downto 0);			  
           selection_symbol : in  STD_LOGIC);
	end component;	
	component reverse_order_reg is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
--			  temp2_out : OUT  std_logic_vector(127 downto 0);
           reset : in  STD_LOGIC);
	end component;
	component KeySchedule_inverse_top is
	Port ( 	  key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
-----------------------------------------------------------------------------------------			  
--			  key_out_1 : out  STD_LOGIC_VECTOR (7 downto 0);
--			  key_out_2 : out  STD_LOGIC_VECTOR (7 downto 0);
----------------------------------------------------------------------------------------			  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
--	component Shiftreg_1 is
--    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
--			  clk,reset : in std_logic;
--           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
--	end component;
	
	
	signal mux0_selection_symbol : std_logic :='0';
	signal reverse_reg_input_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reverse_reg_output_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal keyschedule_inverse_output_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reset_bus_1 : std_logic :='0';
	signal reset_bus_2 : std_logic :='0';
--	signal mux0_input_below_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');



begin


	mux_0 : MUX2 port map (input_up=>key_in, 
								  input_below=>keyschedule_inverse_output_bus, 
								  output_data=>reverse_reg_input_bus,								  
								  selection_symbol=>mux0_selection_symbol);
	reverse_reg : reverse_order_reg port map (data_in=>reverse_reg_input_bus,
															data_out=>reverse_reg_output_bus ,
															clk=>clk,
															reset=>reset_bus_2);
	KeySchedule_inverse : KeySchedule_inverse_top port map (key_in=>reverse_reg_output_bus,
																			  key_out=>keyschedule_inverse_output_bus ,
																			  clk=>clk,
																			  reset=>reset_bus_1);
--	reg1 : Shiftreg_1 port map (data_in=>keyschedule_inverse_output_bus, 
--										 clk=>clk, 
--										 reset=>reset, 
--										 data_out=>mux0_input_below_bus);

key_out <=reverse_reg_output_bus;


process(clk)

variable clk_counter : integer := 1 ;

begin

if reset='1' then 
	mux0_selection_symbol <= '1';	
	clk_counter:=0;
	reset_bus_1<='1';
	reset_bus_2<='1';
else

if rising_edge(CLK) then
	if clk_counter=16 then
		reset_bus_1<='1';
	else 
		reset_bus_1<='0';
	end if;
	
	if clk_counter=32 then
		reset_bus_2<='1';
	else 
		reset_bus_2<='0';
	end if;
	
	if clk_counter<18 then	
		mux0_selection_symbol <= '0';		
	else		
		mux0_selection_symbol <= '1';
	end if;	
	clk_counter := clk_counter+1;
--	if clk_counter=17 then
--		clk_counter := 1;
--	end if;
	
end if;
end if;

end process;


end Behavioral;

