
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY shiftrow_test_bench IS
END shiftrow_test_bench;
 
ARCHITECTURE behavior OF shiftrow_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shiftrow_new
    PORT(
         Input_data : IN  std_logic_vector(7 downto 0);
         Output_data : OUT  std_logic_vector(7 downto 0);
         Decrypt : IN  std_logic;
         Clk : IN  std_logic;
         Reset : IN  std_logic
        );
    END COMPONENT;
     

   --Inputs
   signal Input_data : std_logic_vector(7 downto 0) := (others => '0');
   signal Decrypt : std_logic := '1';
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '0';

 	--Outputs
   signal Output_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shiftrow_new PORT MAP (
          Input_data => Input_data,
          Output_data => Output_data,
          Decrypt => Decrypt,
          Clk => Clk,
          Reset => Reset
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '1';
		wait for Clk_period/2;
		Clk <= '0';
		wait for Clk_period/2;
   end process;
	
	reset<= '1','0' after 20ns;
	
process(CLK,RESET)
variable counter: integer:=0;
begin
	if reset='1' then
		counter:=1;
	elsif rising_edge(clk) then
		Input_data<=conv_std_logic_vector(counter,8);
		counter := counter+1;
		if counter>16 then
			counter:=1;
		end if;	
	end if;
end process;

--stim_proc: process
--   begin	
--		wait for clk_period;	
--		wait for clk_period;
--		Input_data <= x"01";
--		wait for clk_period;
--		
--		Input_data <= x"02";
--		wait for clk_period;
--		
--		Input_data <= x"03";
--		wait for clk_period;
--		
--		Input_data <= x"04";
--		wait for clk_period;
--		
--		
--		Input_data <= x"05";
--		wait for clk_period;
--		
--		Input_data <= x"06";
--		wait for clk_period;
--		
--		Input_data <= x"07";
--		wait for clk_period;
--		
--		Input_data <= x"08";
--		wait for clk_period;
--		
--		
--		Input_data <= x"09";
--		wait for clk_period;
--		
--		Input_data <= x"0a";
--		wait for clk_period;
--		
--		Input_data <= x"0b";
--		wait for clk_period;
--		
--		Input_data <= x"0c";
--		wait for clk_period;
--		
--		
--		Input_data <= x"0d";
--		wait for clk_period;
--		
--		Input_data <= x"0e";
--		wait for clk_period;
--		
--		Input_data <= x"0f";
--		wait for clk_period;
--		
--		Input_data <= x"10";
--		wait for clk_period;
--
--      wait;
--
--      wait;
--   end process;

END;
