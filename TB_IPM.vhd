LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TB_IPM is
END TB_IPM;

architecture beh of TB_IPM is

	component IP_MANAGER 
		port(	
			clk, rst          	: in std_logic;		
			data			: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in       		: out std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable 		: out std_logic;
			R_enable 		: out std_logic;
			generic_en		: out std_logic;
			interrupt		: out std_logic;

			row_0			: inout std_logic_vector (DATA_WIDTH-1 downto 0); 
			
			data_IPs		: inout data_array; 							
			add_in_IPs     		: in add_array;
			W_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs		: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs		: in std_logic_vector(NUM_IPS-1 downto 0)		
			);
	end component;

	
