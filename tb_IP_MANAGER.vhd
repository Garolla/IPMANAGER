LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

ENTITY TB_IP_MANAGER is
END TB_IP_MANAGER;

architecture beh of TB_IP_MANAGER is

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
            W_enable_IPs    : in std_logic_vector(0 to NUM_IPS-1);    
            R_enable_IPs    : in std_logic_vector(0 to NUM_IPS-1);                
            generic_en_IPs  : in std_logic_vector(0 to NUM_IPS-1);    
            enable_IPs      : out std_logic_vector(0 to NUM_IPS-1);    
            ack_IPs         : out std_logic_vector(0 to NUM_IPS-1);    
            interrupt_IPs   : in std_logic_vector(0 to NUM_IPS-1)     	
			);
	end component;
	
	-- inputs --
	signal clk, rst : std_logic := '0';
	signal data_out, row_0 : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
	signal data_in_IPs: data_array := (others => (others => '0'));
	signal add_IPs: add_array := (others => (others => '0'));
	signal W_enable_IPs, R_enable_IPs, generic_en_IPs, interrupt_IPs : std_logic_vector(0 to NUM_IPS-1) := (others => '0');

	-- outputs --
    signal data_in : std_logic_vector (DATA_WIDTH-1 downto 0);
    signal data_out_IPs: data_array;
	signal add : std_logic_vector(ADD_WIDTH-1 downto 0);
	signal W_enable, R_enable, generic_en, interrupt : std_logic;
	signal enable_IPs, ack_IPs : std_logic_vector(0 to NUM_IPS-1);

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
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		
------------------------------------    INITIALIZING IPs after reset  -------------------------------------------------------------------------		

        data_in_IPs(0)  <= conv_std_logic_vector(53, DATA_WIDTH);  	
        add_IPs(0) <= conv_std_logic_vector(15, ADD_WIDTH); 
        W_enable_IPs(0) <= '1'; R_enable_IPs(0) <= '0'; generic_en_IPs(0) <= '1';   -- Write
        
        data_in_IPs(1)  <= conv_std_logic_vector(189, DATA_WIDTH);  
        add_IPs(1) <= conv_std_logic_vector(2, ADD_WIDTH);  
        W_enable_IPs(1) <= '0'; R_enable_IPs(1) <= '1'; generic_en_IPs(1) <= '1';	-- Read 1st operand
        	
        data_in_IPs(2)  <= conv_std_logic_vector(74, DATA_WIDTH);  	
        add_IPs(2) <= conv_std_logic_vector(63, ADD_WIDTH); 
        W_enable_IPs(2) <= '1'; R_enable_IPs(2) <= '1'; generic_en_IPs(2) <= '0';	-- Nothing
         
        data_in_IPs(3)  <= conv_std_logic_vector(12, DATA_WIDTH);   
        add_IPs(3) <= conv_std_logic_vector(8, ADD_WIDTH);  
        W_enable_IPs(3) <= '1'; R_enable_IPs(3) <= '1'; generic_en_IPs(3) <= '1';   -- Write
        
        -- The Data Buffer offers some random data
        data_out        <= conv_std_logic_vector(393, DATA_WIDTH);  
		wait for clk_period;
		
------------------------------------    TESTING SWITCHING CAPABILITIES  -------------------------------------------------------------------------		
		-- IP manager - Nothing expected
		row_0 <= "0001000000000000";
		
		wait for clk_period;
        -- IP 1 - Exptecting data_in = 189 ; enable_IPs(1) = 1 ; W_enable = '1'; R_enable = '0'; generic_en_IPs = '1';
        row_0 <= "0001000000000010";		                                         
		wait for clk_period;
	    
	    data_in_IPs(1)  <= conv_std_logic_vector(66, DATA_WIDTH);   	
        data_in_IPs(2)  <= conv_std_logic_vector(103, DATA_WIDTH); 
         	

        add_IPs(1) <= conv_std_logic_vector(3, ADD_WIDTH);  
        W_enable_IPs(1) <= '0'; R_enable_IPs(1) <= '1'; generic_en_IPs(1) <= '1';    -- Ask to read 2nd operand
        
		wait for clk_period;
		
		data_out        <= conv_std_logic_vector(7, DATA_WIDTH); 	                 -- Receive the 2nd operand
		data_in_IPs(1)  <= conv_std_logic_vector(400, DATA_WIDTH);  
        add_IPs(1)      <= conv_std_logic_vector(4, ADD_WIDTH);  
        W_enable_IPs(1) <= '1'; R_enable_IPs(1) <= '0'; generic_en_IPs(1) <= '1';    -- Write result
		
		wait for clk_period;
	    -- IP 1 - End of transaction
        row_0 <= "0000000000000010";            	
		wait for clk_period;

		-- IP 3 - Exptecting data_in = 103 ; enable_IPs(3) = 1 ; W_enable = '1'; R_enable = '1'; generic_en_IPs = '1';
		row_0 <= "0001000000000100";
		wait for clk_period;
		
	    -- IP 3 - End of transaction
        row_0 <= "0000000000000100";  
        wait for clk_period;		


------------------------------------    TESTING INTERRUPT HANDLING  -------------------------------------------------------------------------		
       
        -- IP 2 - Exptecting data_in = 74 ; enable_IPs(2) = 1 ; W_enable = '1'; R_enable = '1'; generic_en_IPs = '0';
        row_0 <= "0001000000000011";
		-- IP 2 attempts to send an interrupt: nothing should happen
        interrupt_IPs(2) <= '1';
        
        wait for clk_period;
		-- IP 1 attempts to send an interrupt: nothing should happen
        interrupt_IPs(1) <= '1';     
        wait for clk_period;
        
        -- IP 2 - End of transaction. Now the IPM can start handling interrupt:
        -- Expecting interrupt = 1 ; data_in = 0000000000000010
        row_0 <= "0000000000000011";             
        wait for clk_period;
        
        -- The cpu must serve the third ip - IP 2
        row_0 <= "0011000000000010";                                                 
        wait for clk_period;
		-- Once the request is served, the respective ack must go to 1
        if ack_IPs(1) /= '1' then
            wait until ack_IPs(1) = '1';
        end if; 
        interrupt_IPs(1) <= '0';
        -- End of the interrupt request. Now the IPM can start the second handling interrupt:
        -- Expecting interrupt = 1 ; data_in = 0010000000000011
        row_0 <= "0010000000000010";                                                 
        wait for clk_period;       
        
        -- The cpu must serve the second ip - IP 1
        row_0 <= "0011000000000011";                                                 
        wait for clk_period;
        -- Once the request is served, the respective ack must go to 1
        if ack_IPs(2) /= '1' then
            wait until ack_IPs(2) = '1';
        end if; 
        
        interrupt_IPs(2) <= '0';   
        -- End of the interrupt request
        row_0 <= "0000000000000011";                                                 
        wait for clk_period;               
           
      
		
		wait;

		
	end process;
end;
