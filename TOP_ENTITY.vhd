library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity TOP_ENTITY is
	port(	
			clk, rst        : in std_logic;		
			data			: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in	        : in std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable  		: in std_logic;
			R_enable  		: in std_logic;
			generic_en		: in std_logic;
			interrupt		: out std_logic;
			
			data_IPs		: inout data_array; -- There is one data_IP for each IP core 
			add_in_IPs     	: in add_array;
			W_enable_IPs  	: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs  	: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs	: out std_logic_vector(NUM_IPS-1 downto 0);
			interrupt		: out std_logic;
			);
end entity TOP_ENTITY;

architecture STRUCTURAL of TOP_ENTITY is

	component DATA_BUFFER is
		port(	
				clk, rst        : in std_logic;		
				row_0			: out std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
				--PORT_0
				data_cpu		: inout std_logic_vector (DATA_WIDTH-1 downto 0);
				address_cpu     : in std_logic_vector(ADD_WIDTH-1 downto 0);
				WE_CPU 			: in std_logic;
				RE_CPU 			: in std_logic;
				GE_CPU			: in std_logic;
			
				--PORT_1
				data_io		  	: inout std_logic_vector (DATA_WIDTH-1 downto 0);
				address_ip     	: in std_logic_vector(ADD_WIDTH-1 downto 0);
				WE_CPU 			: in std_logic;
				RE_CPU  		: in std_logic;
				GE_CPU			: in std_logic
				);
	end component DATA_BUFFER;

	component IP_MANAGER is
		port(	
				clk, rst        : in std_logic;		
				data			: inout std_logic_vector (DATA_WIDTH-1 downto 0);
				add_in       	: out std_logic_vector(ADD_WIDTH-1 downto 0);
				W_enable 		: out std_logic;
				R_enable 		: out std_logic;
				generic_en		: out std_logic;
				interrupt		: out std_logic;

				row_0			: in std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
				
				data_IPs		: inout data_array; -- There is one data_IP for each IP core 
				add_in_IPs     	: in add_array;
				W_enable_IPs  	: in std_logic_vector(NUM_IPS-1 downto 0);	
				R_enable_IPs  	: in std_logic_vector(NUM_IPS-1 downto 0);				
				generic_en_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
				enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
				ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
				interrupt_IPs	: out std_logic_vector(NUM_IPS-1 downto 0)		
				);
	end component IP_MANAGER;
	
	--Signals between the buffer and the ip manager
	signal		row_0_man		  	:  std_logic_vector (DATA_WIDTH-1 downto 0); 
	signal		data_man		  	:  std_logic_vector (DATA_WIDTH-1 downto 0);
	signal		add_in_man     		:  std_logic_vector(ADD_WIDTH-1 downto 0);
	signal		W_enable_man		:  std_logic;
	signal		R_enable_man		:  std_logic;
	signal		generic_en_man		:  std_logic;
	
begin

	data_buff: DATA_BUFFER
		port map(	
				clk 			=>	clk,
				rst				=>	rst,
				row_0			=>	row_0_man,
				--PORT_0
				data_cpu		=>	data,
				address_cpu		=>	add_in,
				WE_CPU	 		=>	W_enable,
				RE_CPU	 		=>	R_enable,
				GE_CPU			=>	generic_en,
				--PORT_1
				data_ip			=>	data_man,
				address_ip      	=>	add_in_man,
				WE_IP			=>	W_enable_man,
				RE_IP			=>	R_enable_man,
				GE_IP			=>	generic_en_man
				
				);
				
	ip_man: IP_MANAGER 
		port map(	
				clk 			=>	clk,
				rst				=>	rst,
				data			=>	data_man,
				add_in      	=>	add_in_man,
				W_enable		=>	W_enable_man,
				R_enable		=>	R_enable_man,
				generic_en		=>	generic_en_man,
				interrupt		=>  interrupt,
				row_0			=>	row_0_man,
				data_IPs		=>	data_IPs,
				add_in_IPs		=>	add_in_IPs,
				W_enable_IPs	=>	W_enable_IPs,
				R_enable_IPs  	=>	R_enable_IPs,			
				generic_en_IPs	=>	generic_en_IPs,
				enable_IPs		=>	enable_IPs,
				ack_IPs			=>	ack_IPs,
				interrupt_IPs	=>	interrupt_IPs
				);

end architecture;
