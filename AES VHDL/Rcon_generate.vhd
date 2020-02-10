----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:11:05 02/22/2019 
-- Design Name: 
-- Module Name:    Rcon_generate - Behavioral 
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

entity Rcon_generate is
    Port ( rcon_controller : in  STD_LOGIC_VECTOR (3 downto 0);
			  clk,reset : in std_logic;
           rcon_output : out  STD_LOGIC_VECTOR (7 downto 0));
end Rcon_generate;

architecture Behavioral of Rcon_generate is

signal temp : std_logic_vector (7 downto 0):=(others=>'0');

begin

rcon_output <= temp; 

process(clk,reset)

begin

if reset='1' then
	temp <= (others=>'0');
else
	if rising_edge(CLK) then
		case rcon_controller is
			when "0001"=>temp<=x"01";
			when "0010"=>temp<=x"02";
			when "0011"=>temp<=x"04";
			when "0100"=>temp<=x"08";
			when "0101"=>temp<=x"10";
			
			when "0110"=>temp<=x"20";
			when "0111"=>temp<=x"40";
			when "1000"=>temp<=x"80";
			when "1001"=>temp<=x"1b";
			when "1010"=>temp<=x"36";
			
			when others=>temp<=x"00";
		end case;
		
	end if;
end if;

end process;

end Behavioral;

