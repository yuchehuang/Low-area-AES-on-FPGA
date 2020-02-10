--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:05:03 03/28/2019
-- Design Name:   
-- Module Name:   D:/FPGA_project/AES_combine/AES_combine/router_sel_test_bench.vhd
-- Project Name:  AES_combine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: router_sel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY router_sel_test_bench IS
END router_sel_test_bench;
 
ARCHITECTURE behavior OF router_sel_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT router_sel
    PORT(
         data_0 : IN  std_logic_vector(7 downto 0);
         data_1 : IN  std_logic_vector(7 downto 0);
         sel : IN  std_logic;
         Q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_0 : std_logic_vector(7 downto 0) := (others => '0');
   signal data_1 : std_logic_vector(7 downto 0) := (others => '0');
   signal sel : std_logic := '0';

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: router_sel PORT MAP (
          data_0 => data_0,
          data_1 => data_1,
          sel => sel,
          Q => Q
        );

	data_0<=x"0f";
	data_1<=x"f0";
	sel<='0' ,'1' after 50 ns;
	
END;
