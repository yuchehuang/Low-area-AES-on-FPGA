----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:15 03/22/2019 
-- Design Name: 
-- Module Name:    KeySchedule - Behavioral 
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

entity KeySchedule is
    Port ( key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
			  select_symbol : in std_logic;		  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end KeySchedule;

architecture Behavioral of KeySchedule is

	component MUX2 is
	 Port ( input_up : in  STD_LOGIC_VECTOR (7 downto 0);
           input_below : in  STD_LOGIC_VECTOR (7 downto 0);
           output_data : out  STD_LOGIC_VECTOR (7 downto 0);			  
           selection_symbol : in  STD_LOGIC);
	end component;
	
	component KeySchedule_top is
	 Port ( key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;		  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;

	component KeySchedule_inverse_block is
	 Port ( key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;		  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;

	signal keyschedule_forward_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal keyschedule_inverse_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal output_data_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');

begin
	
	
	KeySchedule_forward : KeySchedule_top port map (key_in=>key_in,
																			  key_out=>keyschedule_forward_bus ,
																			  clk=>clk,
																			  reset=>reset);
	KeySchedule_inverse : KeySchedule_inverse_block port map (key_in=>key_in,
																			  key_out=>keyschedule_inverse_bus ,
																			  clk=>clk,
																			  reset=>reset);
	mux : MUX2 port map (input_up=>keyschedule_forward_bus, 
								  input_below=>keyschedule_inverse_bus, 
								  output_data=>output_data_bus,								  
								  selection_symbol=>select_symbol);
								  
key_out <= output_data_bus;

end Behavioral;

