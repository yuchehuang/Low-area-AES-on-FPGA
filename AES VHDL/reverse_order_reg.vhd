----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:10:30 03/17/2019 
-- Design Name: 
-- Module Name:    reverse_order_reg - Behavioral 
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

entity reverse_order_reg is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
--			  temp2_out : OUT  std_logic_vector(127 downto 0);
           reset : in  STD_LOGIC);
end reverse_order_reg;

architecture Behavioral of reverse_order_reg is

signal temp : std_logic_vector (127 downto 0):=(others=>'0');
signal temp2 : std_logic_vector (127 downto 0):=(others=>'0');

begin

--data_out <= temp3;
--temp2_out<=temp2;

process(clk,reset,data_in)

variable clk_counter : integer := 1 ;

begin

if reset='1' then
	temp <= (others=>'0');
	temp2 <= (others=>'0');
	clk_counter := 1;
elsif rising_edge(CLK) then	
	temp<=temp(119 downto 0) & data_in;
	clk_counter:= clk_counter + 1;
	data_out <= temp2(7 downto 0);
	temp2<=x"00" & temp2(127 downto 8) ;
	
	 if(clk_counter> 16) then 
			temp2<=temp(119 downto 0) & data_in;
			clk_counter:=1;
	 end if;
	 

	

end if;
end process;


end Behavioral;


