library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity AES is
	Port(	data_in: in STD_LOGIC_VECTOR(7 downto 0);
			key_in: in STD_LOGIC_VECTOR(7 downto 0);
			output: out STD_LOGIC_VECTOR(7 downto 0);
			reset: in STD_LOGIC;
			sel: in STD_LOGIC;
			CLK: in STD_LOGIC
			); 
end AES;

architecture Behavioral of AES is

component  SubByte_no_clk is
	Port(	data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			data_output: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Sel: in STD_LOGIC);
end component;

component shiftrow_new is
    Port ( Input_data :  in  STD_LOGIC_VECTOR(7 downto 0);          
           Output_data : out  STD_LOGIC_VECTOR(7 downto 0);
			  Decrypt : in STD_LOGIC;
           Clk : in  STD_LOGIC;
			  Reset : in STD_LOGIC);
end component;	

component Mixcolumn is
    Port ( Input : in  STD_LOGIC_VECTOR (7 downto 0);
           output : out  STD_LOGIC_VECTOR(7 downto 0);
			  clk: in std_logic;
			  Decrypt: in std_logic;
			  reset: in std_logic
			  );	  
end component;

component KeySchedule is
    Port ( key_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  clk,reset : in std_logic;
			  select_symbol : in std_logic;		  
           key_out : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


component router_sel is
port (
    Data_0: in STD_LOGIC_VECTOR(7 downto 0);
	 Data_1: in STD_LOGIC_VECTOR(7 downto 0);
	 sel: in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component delay is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;


component delay_4 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;

component delay_3 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;

component delay_8 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;

component delay_32 is
port (
    Data: in STD_LOGIC_VECTOR(7 downto 0);
    CLK : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR(7 downto 0);
	 reset : in STD_LOGIC
  );
end component;
	----------------result  for selector-------------------------------
	signal decision_0 : STD_LOGIC_VECTOR (7 downto 0);		-- Data => the decision for chosing delay32 path or not
	signal decision_1 : STD_LOGIC_VECTOR (7 downto 0);		-- Key  => the decision for chosing delay32 path or not
	signal decision_2 : STD_LOGIC_VECTOR (7 downto 0);		-- disgingush 1 or 2-10 round
	signal decision_3 : STD_LOGIC_VECTOR (7 downto 0);		-- go 4 delay and addroundkey  or go straight
	signal decision_4 : STD_LOGIC_VECTOR (7 downto 0);		-- go mix_col and addroundkey  or go straight 
	signal decision_5 : STD_LOGIC_VECTOR (7 downto 0);		
	signal decision_6 : STD_LOGIC_VECTOR (7 downto 0);	
	signal decision_7 : STD_LOGIC_VECTOR (7 downto 0);
	signal decision_8 : STD_LOGIC_VECTOR (7 downto 0);
	----------------pin name for each moudle -------------------------------
	signal key_out : STD_LOGIC_VECTOR (7 downto 0);
	signal key_temp : STD_LOGIC_VECTOR (7 downto 0);
	signal sub_out: STD_LOGIC_VECTOR (7 downto 0);
	signal shift_out: STD_LOGIC_VECTOR (7 downto 0);
	signal mix_out: STD_LOGIC_VECTOR (7 downto 0);
	---------------Add round key operation output --------------------
	signal addroundkey_1: STD_LOGIC_VECTOR (7 downto 0);		-- the first addroundkey
	signal addroundkey_2: STD_LOGIC_VECTOR (7 downto 0);
	signal addroundkey_3: STD_LOGIC_VECTOR (7 downto 0);
	signal addroundkey_4: STD_LOGIC_VECTOR (7 downto 0);
	----------------For 32 CLk delay pin name-------------------------
	signal key_delay_output: STD_LOGIC_VECTOR (7 downto 0);
	signal Data_in_delay_output: STD_LOGIC_VECTOR (7 downto 0); -- (decode path)
	signal key_Predelay_output: STD_LOGIC_VECTOR (7 downto 0);
	signal Data_Predelay_output: STD_LOGIC_VECTOR (7 downto 0); -- (decode path)
	signal Data_8_output: STD_LOGIC_VECTOR (7 downto 0);			-- wait for shiftrow finish a round
	signal Key_11_output: STD_LOGIC_VECTOR (7 downto 0);			-- synchronize with data 
	signal delay_to_mix_output: STD_LOGIC_VECTOR (7 downto 0); -- (decode path)  the second addround delay 
	signal delay_to_output: STD_LOGIC_VECTOR (7 downto 0);		-- delay in final add round key
	signal first_round: STD_LOGIC:= '0';	--control the first round selector
	signal first_round_delay_8: STD_LOGIC:= '0';
	signal first_round_delay_for_addroundkey: STD_LOGIC:= '0';	
	signal gate_enable: STD_LOGIC:= '0';	--control Gate selector
	signal syn: STD_LOGIC:= '1';	--control Gate selector
	signal key_syn: STD_LOGIC:= '1';	--control Gate selector
	signal key_delay_sel: STD_LOGIC:= '1';	--control Gate selector
begin

	-------------- Pre delay circuit------------------------------------------
	data_pre_delay: delay port map (Data=>data_in,Q=>Data_Predelay_output,CLK=>clk,reset=>reset);
	Key_pre_delay: delay port map (Data=>key_in,Q=>key_Predelay_output,CLK=>clk,reset=>reset);
	data_decode_delay: delay_32 port map (Data=>Data_Predelay_output,Q=>Data_in_delay_output,CLK=>clk,reset=>reset);
	key_decode_delay: delay_32 port map (Data=>key_Predelay_output,Q=>key_delay_output,CLK=>clk,reset=>reset);
	
	
	selector_0: router_sel port map(data_0=>Data_Predelay_output, data_1=>Data_in_delay_output, Q=>decision_0,sel=>sel);
	selector_1: router_sel port map(data_0=>key_Predelay_output, data_1=> key_delay_output, Q=>decision_1,sel=>sel);	--distinguish the different dealy due to key schedule
	addroundkey_1<=decision_0 xor decision_1;		--the first round add round key
	selector_2: router_sel port map(data_0=>addroundkey_1, data_1=> decision_4, Q=>decision_2,sel=>first_round);	-- distinguish the first round and the others round
	subByte : SubByte_no_clk port map(data_in=>decision_2,Sel=>sel,data_output=>sub_out);
	shift: shiftrow_new port map(Input_data=>sub_out,Output_data=>shift_out,Decrypt=>sel,Clk=>clk,Reset=>syn);
	
	
	delay4_to_mix_col: delay_4 port map(Data=>shift_out,Q=>delay_to_mix_output,CLK=>clk,reset=>reset);
	selector_5: router_sel port map(data_0=>delay_to_mix_output, data_1=>shift_out, Q=>decision_5,sel=>first_round_delay_for_addroundkey);
	addroundkey_2<=decision_5 xor key_out;
	delay8_to_mix_col: delay_8 port map(Data=>addroundkey_2,Q=>Data_8_output,CLK=>clk,reset=>reset);
	selector_7: router_sel port map(data_0=>Data_8_output, data_1=>addroundkey_2, Q=>decision_7,sel=>first_round_delay_8);
	
	selector_3: router_sel port map(data_0=>shift_out, data_1=>decision_7, Q=>decision_3,sel=>sel);	 
	mix: Mixcolumn port map(Input=>decision_3,output=>mix_out,clk=>clk,Decrypt=>sel,reset=>syn);
	addroundkey_3<=mix_out xor key_out;	
	selector_4: router_sel port map(data_0=>addroundkey_3, data_1=>mix_out, Q=>decision_4,sel=>sel);	 
	
	
	delay4_to_output: delay_3 port map(Data=>shift_out,Q=>delay_to_output,CLK=>clk,reset=>reset);
	selector_6: router_sel port map(data_0=>delay_to_output, data_1=>shift_out, Q=>decision_6,sel=>sel);
	addroundkey_4<=key_out xor decision_6;
	
	Gate: router_sel port map(data_0=> X"00", data_1=>addroundkey_4, Q=>output,sel=>gate_enable);
	key: KeySchedule port map(key_in=> key_Predelay_output,key_out=>key_temp ,clk=>clk,reset=>key_syn,select_symbol=>sel);
	key_delay_11: delay_8 port map(Data=>key_temp,Q=>Key_11_output,CLK=>clk,reset=>reset);
	selector_8: router_sel port map(data_0=>key_temp, data_1=>Key_11_output, Q=>key_out,sel=>key_delay_sel);
	

	
process(reset,CLK,first_round,syn,sel)
	variable counter: integer:=0;
	begin
		if reset='1' then 
			first_round<='0';	
			gate_enable<='0';
			syn<='1';			-- due to the first data will be read for 1 clk later 
			key_syn<='1';		-- due to the first data will be read for 1 clk later  
			key_delay_sel<='0';
		elsif rising_edge(clk) then 
			
				if sel='0' then--------------------------Encoding--------------------------------------
					key_syn<='0';
					syn<='0';
					if counter =17 then  	
						first_round<='1';		--changing into the loop
					elsif counter=161 then
						gate_enable<='1';		--open the output gate
					elsif counter=177 then
						gate_enable<='0';
						counter:=0;
					end if;
				else--------------------------Decoding--------------------------------------
					key_syn<='0';			
					if counter <34 then
						syn<='1';			-- data wait for 33 clk due to inverse key schedule
					else
						syn<='0';
					end if;
					if counter =52 then
					first_round<='1';		--changing into the loop
					elsif counter=67 then
					key_delay_sel<='1';		-- the second addround CLk signal syn
					elsif counter=69 then
					first_round_delay_for_addroundkey<='1';	--wait for shiftrow starting new round 
					elsif counter=79 then
					first_round_delay_8<='1';						--changing  the path to wait for shiftrow starting new round 
					elsif counter=207 then
					gate_enable<='1';
					elsif counter=223 then
					gate_enable<='0';
					counter:=0;
					end if;
				end if;	
				
				counter:=counter+1;
	
		end if;	
	end process;
	
		

end Behavioral;

