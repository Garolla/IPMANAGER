library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;

--IMPORTANT: The number of IPs must be written in the file CONSTANTS.vhd. The IPs core must be then connected at the end of this file
entity TOP_ENTITY is
	port(	
			clock			: in std_logic;	
			reset			: in std_logic;		
			data			: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			address	        : in std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable  		: in std_logic;
			R_enable  		: in std_logic;
			generic_enable	: in std_logic;
			interrupt		: out std_logic
			);
end entity TOP_ENTITY;

architecture STRUCTURAL of TOP_ENTITY is

	--Signals between the buffer and the ip manager
	signal	row_0			  	: std_logic_vector (DATA_WIDTH-1 downto 0); 
	signal	data_in_ip		  	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal	data_out_ip			: std_logic_vector (DATA_WIDTH-1 downto 0);	
	signal	address_ip     		: std_logic_vector (ADD_WIDTH-1 downto 0);
	signal	WE_IP				: std_logic;
	signal	RE_IP				: std_logic;
	signal	GE_IP				: std_logic;
	--Signals between the IP manager and the various IP cores
	signal	data_in_IPs     	: data_array; 
	signal	data_out_IPs    	: data_array;     
	signal	add_IPs         	: add_array;            
	signal	W_enable_IPs    	: std_logic_vector(0 to NUM_IPS-1);    
	signal	R_enable_IPs    	: std_logic_vector(0 to NUM_IPS-1);                
	signal	generic_en_IPs  	: std_logic_vector(0 to NUM_IPS-1);    
	signal	enable_IPs      	: std_logic_vector(0 to NUM_IPS-1);    
	signal	ack_IPs         	: std_logic_vector(0 to NUM_IPS-1);    
	signal	interrupt_IPs   	: std_logic_vector(0 to NUM_IPS-1);    
	
begin

	-- IMPORTANT: Change BEHAVIOURAL to STRUCTURAL and viceversa to test the different architecture
	data_buff: entity work.DATA_BUFFER(BEHAVIOURAL)
		port map(	rst				=>	reset,
					row_0			=>	row_0,
					--PORT_0
					data_cpu		=>	data,
					address_cpu		=>	address,
					WE_CPU	 		=>	W_enable,
					RE_CPU	 		=>	R_enable,
					GE_CPU			=>	generic_enable,
					--PORT_1
					data_in_ip		=>	data_in_ip,
					data_out_ip		=>	data_out_ip,
					address_ip      =>	address_ip,
					WE_IP			=>	WE_IP,
					RE_IP			=>	RE_IP,
					GE_IP			=>	GE_IP);
				
	ip_man: entity work.IP_MANAGER 
		port map(	clk 			=>	clock,
					rst				=>	reset,
					data_in			=>	data_in_ip,
					data_out		=>	data_out_ip,				
					add           	=>	address_ip,
					W_enable		=>	WE_IP,
					R_enable		=>	RE_IP,
					generic_en		=>	GE_IP,
					interrupt		=>  interrupt,
					row_0			=>	row_0,
					data_in_IPs		=>	data_in_IPs,
					data_out_IPs	=>	data_out_IPs,				
					add_IPs		    =>	add_IPs,
					W_enable_IPs	=>	W_enable_IPs,
					R_enable_IPs  	=>	R_enable_IPs,			
					generic_en_IPs	=>	generic_en_IPs,
					enable_IPs		=>	enable_IPs,
					ack_IPs			=>	ack_IPs,
					interrupt_IPs	=>	interrupt_IPs);
	
	-- IMPORTANT: Instantiate here the IP cores. 
	-- The port map is the same for every IP, only the numbers must be changed. 
	-- All zeros for IP_0 ( Highest interrupt priority), all ones for IP_1 and so on. IP_N has the lowest priority
	
	 ip_0: entity work.IP_DUMMY	
		port map(	clk				=> clock, 
					rst				=> reset, 
					data_in			=> data_in_IPs(0),
					data_out		=> data_out_IPs(0),
					address			=> add_IPs(0),
					W_enable		=> W_enable_IPs(0),
					R_enable		=> R_enable_IPs(0),
					generic_en		=> generic_en_IPs(0),
					enable			=> enable_IPs(0),
					ack				=> ack_IPs(0),
					interrupt		=> interrupt_IPs(0));		
						
	 ip_1: entity work.IP_ADDER	
		port map(	clk				=> clock, 
					rst				=> reset, 
					data_in			=> data_in_IPs(1),
					data_out		=> data_out_IPs(1),
					address			=> add_IPs(1),
					W_enable		=> W_enable_IPs(1),
					R_enable		=> R_enable_IPs(1),
					generic_en		=> generic_en_IPs(1),
					enable			=> enable_IPs(1),
					ack				=> ack_IPs(1),
					interrupt		=> interrupt_IPs(1));	
					
	 ip_2: entity work.IP_DUMMY	
		port map(	clk				=> clock, 
					rst				=> reset, 
					data_in			=> data_in_IPs(2),
					data_out		=> data_out_IPs(2),
					address			=> add_IPs(2),
					W_enable		=> W_enable_IPs(2),
					R_enable		=> R_enable_IPs(2),
					generic_en		=> generic_en_IPs(2),
					enable			=> enable_IPs(2),
					ack				=> ack_IPs(2),
					interrupt		=> interrupt_IPs(2));	
										
	 ip_3: entity work.IP_DUMMY	
		port map(	clk				=> clock, 
					rst				=> reset, 
					data_in			=> data_in_IPs(3),
					data_out		=> data_out_IPs(3),
					address			=> add_IPs(3),
					W_enable		=> W_enable_IPs(3),
					R_enable		=> R_enable_IPs(3),
					generic_en		=> generic_en_IPs(3),
					enable			=> enable_IPs(3),
					ack				=> ack_IPs(3),
					interrupt		=> interrupt_IPs(3));											
end architecture;
