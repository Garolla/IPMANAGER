library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity IP_MANAGER is
	port(	
			clk, rst          	: in std_logic;		
			data			  	: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in       		: out std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable 			: out std_logic;
			R_enable 			: out std_logic;
			generic_en			: out std_logic;

			row_0			  	: in std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
			
			data_IPs		  	: inout data_array; -- There is one data_IP for each IP core 
			add_in_IPs     		: in add_array;
			W_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs		: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs				: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs		: out std_logic_vector(NUM_IPS-1 downto 0)		
			);
end entity IP_MANAGER;

architecture BEHAVIOURAL of IP_MANAGER is
	--TODO
begin
	--TODO

end architecture;
