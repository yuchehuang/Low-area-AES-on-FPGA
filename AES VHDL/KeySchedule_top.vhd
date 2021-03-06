----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:18:45 02/22/2019 
-- Design Name: 
-- Module Name:    KeySchedule_top - Behavioral 
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

entity KeySchedule_top is
    Port ( key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
-----------------------------------------------------------------------------------------			  
--			  key_out_1 : out  STD_LOGIC_VECTOR (7 downto 0);
--			  key_out_2 : out  STD_LOGIC_VECTOR (7 downto 0);
----------------------------------------------------------------------------------------			  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end KeySchedule_top;

architecture Behavioral of KeySchedule_top is

	component Shiftreg_3 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Shiftreg_1 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Shiftreg_8 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Shiftreg_4 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Shiftreg_2 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component MUX2 is
	 Port ( input_up : in  STD_LOGIC_VECTOR (7 downto 0);
           input_below : in  STD_LOGIC_VECTOR (7 downto 0);
           output_data : out  STD_LOGIC_VECTOR (7 downto 0);
			  
           selection_symbol : in  STD_LOGIC);
	end component;
	
	component Holdreg_1 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
			  hold_symbol : std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;	
	
	component SubByte_no_clk is
    Port(	data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_output: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Sel: in STD_LOGIC);
	end component;
	
	component Rcon_generate is
    Port ( rcon_controller : in  STD_LOGIC_VECTOR (3 downto 0);
			  clk,reset : in std_logic;
           rcon_output : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;



	
	signal cycling_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal mux1_selection_symbol : std_logic :='1';
	signal mux1_to_reg3_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg3_to_reg1_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg1_to_reg8_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg8_to_mux3_bus_1 : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg8_to_mux3_bus_2 : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal mux3_selection_symbol : std_logic:='1';
	signal mux3_to_reg4_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg4_to_mux4_bus_1 : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal reg4_to_mux4_bus_2 : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal mux4_selection_symbol : std_logic:='0';
	
	signal holdreg1_hold_symbol : std_logic:='1';
	signal holdreg1_to_mux2_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal mux2_selection_symbol : std_logic:='0';
	signal mux2_to_sbox_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal sbox_output_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	
   signal rotword_bus_in : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal rotword_bus_out : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal Shift_Holdreg4_hold_symbol : std_logic:='1';
	
	signal rcon_output_bus : STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
	signal rcon_controller_bus : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
	

   
	constant clk_period : time := 10 ns;
	
	
	

begin
	
										 
	mux_1 : MUX2 port map (input_up=>cycling_bus, 
								  input_below=>key_in, 
								  output_data=>mux1_to_reg3_bus,								  
								  selection_symbol=>mux1_selection_symbol);
	
	reg3 : Shiftreg_3 port map (data_in=>mux1_to_reg3_bus, 
										 clk=>clk, 
										 reset=>reset, 
										 data_out=>reg3_to_reg1_bus);
	
	reg1 : Shiftreg_1 port map (data_in=>reg3_to_reg1_bus, 
										 clk=>clk, 
										 reset=>reset, 
										 data_out=>reg1_to_reg8_bus);
	
	reg8 : Shiftreg_8 port map (data_in=>reg1_to_reg8_bus, 
										 clk=>clk, 
										 reset=>reset, 
										 data_out=>reg8_to_mux3_bus_1);
	
	mux_3 : MUX2 port map (input_up=>reg8_to_mux3_bus_2, 
								  input_below=>reg8_to_mux3_bus_1, 
								  output_data=>mux3_to_reg4_bus,								
								  selection_symbol=>mux3_selection_symbol);
	
	reg4 : Shiftreg_4 port map (data_in=>mux3_to_reg4_bus, 
										 clk=>clk, 
										 reset=>reset, 
										 data_out=>reg4_to_mux4_bus_1);
	
	mux_4 : MUX2 port map (input_up=>reg4_to_mux4_bus_1, 
								  input_below=>reg4_to_mux4_bus_2, 
								  output_data=>cycling_bus, 								  
								  selection_symbol=>mux4_selection_symbol);
								  
	
	holdreg1 : Holdreg_1 port map (data_in=>reg1_to_reg8_bus, 
											 clk=>clk, 
											 reset=>reset, 
											 data_out=>holdreg1_to_mux2_bus, 
											 hold_symbol=>holdreg1_hold_symbol);
	
	mux_2 : MUX2 port map (input_up=>reg3_to_reg1_bus, 
								  input_below=>holdreg1_to_mux2_bus, 
								  output_data=>mux2_to_sbox_bus, 								  
								  selection_symbol=>mux2_selection_symbol);
	
	sbox : SubByte_no_clk port map (data_in=>mux2_to_sbox_bus, 
									 Sel=>'0', 
									 data_output=>sbox_output_bus);
	
	
	rcon : Rcon_generate port map (rcon_controller=>rcon_controller_bus, 
											 clk=>clk, 
											 reset=>reset, 
											 rcon_output=>rcon_output_bus);
											 

	key_out <=cycling_bus;	

	reg8_to_mux3_bus_2 <= reg8_to_mux3_bus_1 xor cycling_bus;
	
	rotword_bus_out <= (sbox_output_bus) xor (rcon_output_bus);
	reg4_to_mux4_bus_2 <= reg4_to_mux4_bus_1 xor rotword_bus_out ;
	
process(clk)

variable clk_counter : integer := 1 ;

variable cycling_count : integer := 0 ;


begin

if reset='1' then 
	mux1_selection_symbol <= '1';
	mux2_selection_symbol <= '0';
	mux3_selection_symbol <= '1';
	mux4_selection_symbol <= '0';
	holdreg1_hold_symbol <= '1';
	rcon_controller_bus <= "0000";
	
	clk_counter:=1;
	cycling_count:=0;
	
else

if rising_edge(CLK) then
 

	if cycling_count=0 then
	
		mux1_selection_symbol <= '1';
		mux2_selection_symbol <= '0';
		mux3_selection_symbol <= '1';
		mux4_selection_symbol <= '0';
		holdreg1_hold_symbol <= '1';
		rcon_controller_bus <= "0000";
		
	else
   
		mux1_selection_symbol <= '0';
		

		if clk_counter=4 then
			mux2_selection_symbol <= '1';
		else  
			mux2_selection_symbol <= '0';
		end if;
	
		if clk_counter<13 then
			mux3_selection_symbol <= '0';
		else  
			mux3_selection_symbol <= '1';
		end if;
		
		if clk_counter<5 then
			mux4_selection_symbol <= '1';
		else  
			mux4_selection_symbol <= '0';
		end if;
	
		if clk_counter=1 then
			holdreg1_hold_symbol <= '0';
		elsif clk_counter=5 then
			holdreg1_hold_symbol <= '0';
		else  
			holdreg1_hold_symbol <= '1';
		end if;

	end if;
	
	if clk_counter=16 then
		if cycling_count=0 then 
			rcon_controller_bus <= "0001";
		elsif cycling_count=1 then 
			rcon_controller_bus <= "0010";
		elsif cycling_count=2 then 
			rcon_controller_bus <= "0011";
		elsif cycling_count=3 then 
			rcon_controller_bus <= "0100";
		elsif cycling_count=4 then 
			rcon_controller_bus <= "0101";
		elsif cycling_count=5 then 
			rcon_controller_bus <= "0110";
		elsif cycling_count=6 then 
			rcon_controller_bus <= "0111";
		elsif cycling_count=7 then 
			rcon_controller_bus <= "1000";
		elsif cycling_count=8 then 
			rcon_controller_bus <= "1001";
		elsif cycling_count=9 then 
			rcon_controller_bus <= "1010";
		end if;
	else  
		rcon_controller_bus <= "0000";
	end if;
	
	
	clk_counter := clk_counter+1;
	if clk_counter=17 then
		cycling_count:=cycling_count+1;
		clk_counter := 1;
	end if;
	
end if;
end if;

end process;
end Behavioral;

