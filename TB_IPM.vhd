LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

ENTITY TB_IPM is
END TB_IPM;

architecture beh of TB_IPM is

	component IP_MANAGER 
		port(	
			clk, rst      	: in std_logic;		
			data_in			: out std_logic_vector (DATA_WIDTH-1 downto 0);
			data_out		: in std_logic_vector (DATA_WIDTH-1 downto 0);			
			add     		: out std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable 		: out std_logic;
			R_enable 		: out std_logic;
			generic_en		: out std_logic;
			interrupt		: out std_logic;

			row_0			: in std_logic_vector (DATA_WIDTH-1 downto 0); 
			
			data_in_IPs		: in data_array; 
			data_out_IPs	: out data_array; 										
			add_IPs 		: in add_array;
			W_enable_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs	: in std_logic_vector(NUM_IPS-1 downto 0)		
			);
	end component;
	
	-- inputs --
	signal clk, rst : std_logic := '1';
	signal data_in, row_0 : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal data_in_IPs: data_array;
	signal add_IPs: add_array;	
	signal W_enable_IPs, R_enable_IPs, generic_en_IPs, interrupt_IPs : std_logic_vector(NUM_IPS-1 downto 0);

	-- outputs --
    signal data_out : std_logic_vector (DATA_WIDTH-1 downto 0);
    signal data_out_IPs: data_array;
	signal add : std_logic_vector(ADD_WIDTH-1 downto 0);
	signal W_enable, R_enable, generic_en, interrupt : std_logic;
	signal enable_IPs, ack_IPs : std_logic_vector(NUM_IPS-1 downto 0);

	-- clocks --
	constant clk_period : time := 10 ns;

begin

	-- UUT
	UUT : IP_MANAGER port map (
			clk              => clk, 
			rst              => rst, 
			data_in          => data_in, 
			data_out         => data_out, 
			add              => add, 
			W_enable         => W_enable, 
			R_enable         => R_enable, 
			generic_en       => generic_en, 
			interrupt        => interrupt, 
			row_0            => row_0,
			data_in_IPs      => data_in_IPs, 
			data_out_IPs     => data_out_IPs, 
			add_IPs          => add_IPs,
			W_enable_IPs     => W_enable_IPs, 
			R_enable_IPs     => R_enable_IPs, 
			generic_en_IPs   => generic_en_IPs, 
			enable_IPs       => enable_IPs, 
			ack_IPs          => ack_IPs, 
			interrupt_IPs    => interrupt_IPs
	);

	-- clock process
	clk_process : process 
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;	

		
	-- test process
	test_process : process
	begin
	    wait for 2 ns;
		rst <= '0';
		wait for clk_period;
		rst <= '1';
		-- The IPs write some random data
        data_in_IPs(0)  <= conv_std_logic_vector(53, DATA_WIDTH);  		 
        data_in_IPs(1)  <= conv_std_logic_vector(189, DATA_WIDTH);   		
        data_in_IPs(2)  <= conv_std_logic_vector(74, DATA_WIDTH);  		 
        data_in_IPs(3)  <= conv_std_logic_vector(12, DATA_WIDTH);   
        -- The cpu writes some random data
        data_out        <= conv_std_logic_vector(393, DATA_WIDTH);  
        
		wait for clk_period;
		-- IP manager
		row_0 <= "0001000000000000";
		wait for clk_period;
        -- IP 1 - Exptecting data_in = 53
        row_0 <= "0001000000000001";		
		wait for clk_period;
        -- IP 2 - Exptecting data_in = 189
        row_0 <= "0001000000000010";
		wait for clk_period;
		-- IP 3 - Exptecting data_in = 74
		row_0 <= "0001000000000011";
		wait for clk_period;
        -- IP 4 - Exptecting data_in = 12
        row_0 <= "0001000000000100";
        		
		-- ENABLE_7 should go to 1
--		wait for 5 ns;
--		-- IP 7 tries to read data
--		R_enable_IPs(7) <= '1';		
--		-- we expect to see the data on data_IPs(7)
--		wait for clk_period;
--		-- IP 7 attempts a write
--		R_enable_IPs(7) <= '0';
--		W_enable_IPs(7) <= '1';		
--		data_in_IPs(7) 	 <= "1001010111010001";
--		-- we expect to see the data on "data" 
--		wait for clk_period;
--		-- IP 4 attempts a write: nothing should happen!
--		W_enable_IPs(4) <= '1';
--		data_in_IPs(1) 	 <= "1111000011110000";
--		wait for 4 ns;
--		-- IP 8 attempts a read: nothing should happen!
--		W_enable_IPs(4) <= '0';		
--		R_enable_IPs(8) <= '1';
--		wait for 4 ns;


--		-- IP 3 attempts to send an interrupt: nothing should happen
--		interrupt_IPs(3) <= '1';


--		-- CPU decides to end transaction
--		row_0 <= "0000000000000111";
--		-- ENABLE_7 should go to 0

--		---- interrupt test ----
--		-- the IPM should now recognise the interrupt from IP 3.
--		wait until interrupt = '1';
--		wait for 3 ns;
--		-- send the ack by setting bit 13
--		row_0 <= "0010000000000000";
--		-- we expect ACK_3 to go to 1
--		wait until ack_IPs(3) = '1';
--		interrupt_IPs(3) <= '0';
		
		wait;

		
	end process;
end;
