library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.CONSTANTS.ALL;

entity data_buffer is

	port(
	    
		 rst			 	 : IN    std_logic;
		 ROW_0      	 : OUT   std_logic_vector(DATA_WIDTH - 1 downto 0);
       
		 --PORT_0
		 data_cpu    	 : INOUT std_logic_vector(DATA_WIDTH - 1 downto 0);
	    address_cpu 	 : IN    std_logic_vector(ADD_WIDTH - 1 downto 0);
		 WE_CPU         : IN 	std_logic;
		 RE_CPU         : IN 	std_logic;
		 GE_CPU         : IN 	std_logic;
		 
		 --PORT_1
		 data_in_ip     : IN  std_logic_vector(DATA_WIDTH - 1 downto 0);
		 data_out_ip	 : OUT std_logic_vector(DATA_WIDTH - 1 downto 0);
       address_ip  	 : IN  std_logic_vector(ADD_WIDTH - 1 downto 0);              																					  
		 WE_IP       	 : IN 	std_logic;										  
		 RE_IP       	 : IN 	std_logic;
		 GE_IP       	 : IN 	std_logic
	);



end data_buffer;

architecture Struct of data_buffer is
 
 component REG_0 is
	
	port(
			rst			         : IN  std_logic;
			
			row_0						: OUT std_logic_vector(DATA_WIDTH - 1 downto 0);
			
			-- CPU side
			I_cpu                : IN  std_logic_vector(DATA_WIDTH - 1 downto 0);
			Chosen_cpu    		   : IN  std_logic;
			Write_enable_cpu     : IN  std_logic;
			Read_enable_cpu      : IN  std_logic;
			
			
			-- IP core side
			I_ip_in              : IN   std_logic_vector(DATA_WIDTH - 1 downto 0);
			I_ip_out             : OUT  std_logic_vector(DATA_WIDTH - 1 downto 0);
			Chosen_ip 		      : IN   std_logic;
			Write_enable_ip      : IN   std_logic;
			Read_enable_ip      	: IN   std_logic
	
	);
 
 end component;
 
 component regs_first8_port_map is
 
	port(
			rst			         : IN    std_logic;
	      -- CPU side
			data_cpu					: INOUT std_logic_vector(DATA_WIDTH - 1 downto 0);
			from_cpu_dec			: IN    std_logic_vector(0 to 7);
			WE_CPU					: IN    std_logic;
			RE_CPU					: IN    std_logic;
			-- IP core side
			data_ip_input	      : IN    std_logic_vector(DATA_WIDTH - 1 downto 0);
			data_ip_output	      : OUT   std_logic_vector(DATA_WIDTH - 1 downto 0);
			from_ip_dec		      : IN    std_logic_vector(0 to 7);
			WE_IP						: IN    std_logic;
			RE_IP						: IN    std_logic;
			ROW_0						: OUT   std_logic_vector(DATA_WIDTH - 1 downto 0)
	);

 
 end component;
 
 component regs8_port_map is

  port(
			rst			         : IN  std_logic;
			-- CPU side
			data_cpu					: INOUT std_logic_vector(DATA_WIDTH - 1 downto 0);
			from_cpu_dec			: IN std_logic_vector(0 to 7);
			WE_CPU					: IN std_logic;
			RE_CPU					: IN std_logic;
			-- IP core side
			data_ip_input	      : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
			data_ip_output	      : OUT std_logic_vector(DATA_WIDTH - 1 downto 0);	
			from_ip_dec		      : IN std_logic_vector(0 to 7);
			WE_IP						: IN std_logic;
			RE_IP						: IN std_logic
	
	);
 
 end component;
 
 component REG_16b is
	
	port(
			rst			         : IN     std_logic;
			
			
			-- CPU side
			data_cpu             : INOUT  std_logic_vector(DATA_WIDTH - 1 downto 0);
			Chosen_cpu    		   : IN  	std_logic;
			Write_enable_cpu     : IN  	std_logic;
			Read_enable_cpu      : IN  	std_logic;
			
			-- IP core side
			data_ip_in           : IN	   std_logic_vector(DATA_WIDTH - 1 downto 0);
			data_ip_out          : OUT	   std_logic_vector(DATA_WIDTH - 1 downto 0);
			Chosen_ip 		      : IN     std_logic;
			Write_enable_ip      : IN     std_logic;
			Read_enable_ip       : IN     std_logic
	);
	
 end component;
 
 component decoder6to64 is
   port(
			address 		   : IN  std_logic_vector(5 downto 0);
			generic_enable : IN  std_logic;
			Z              : OUT std_logic_vector(0 to 63)
	);
 end component;


 signal from_cpu_dec 	: std_logic_vector(0 to 63);
 signal from_ip_dec  	: std_logic_vector(0 to 63);


begin

 cpu_decoder : decoder6to64 port map(
                                     address_cpu,
												 GE_CPU,
                                     from_cpu_dec												  
									 ); 

 ip_decoder  : decoder6to64 port map(
                                     address_ip,
												 GE_IP,
												 from_ip_dec
                            );



reg_0_to_7 : regs_first8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(0 to 7),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(0 to 7),
							  WE_IP,
							  RE_IP,
							  ROW_0
				);

reg_8_to_15 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(8 to 15),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(8 to 15),
							  WE_IP,
							  RE_IP
				);				

reg_16_to_23 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(16 to 23),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(16 to 23),
							  WE_IP,
							  RE_IP
				);
				
reg_24_to_31 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(24 to 31),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(24 to 31),
							  WE_IP,
							  RE_IP
				);				
				
reg_32_to_39 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(32 to 39),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(32 to 39),
							  WE_IP,
							  RE_IP
				);				

reg_40_to_47 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(40 to 47),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(40 to 47),
							  WE_IP,
							  RE_IP
				);

reg_48_to_55 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(48 to 55),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(48 to 55),
							  WE_IP,
							  RE_IP
				);

reg_56_to_63 : regs8_port_map port map (
				           rst,
							  data_cpu,
							  from_cpu_dec(56 to 63),
							  WE_CPU,
							  RE_CPU,
							  data_in_ip,
							  data_out_ip,
							  from_ip_dec(56 to 63),
							  WE_IP,
							  RE_IP
				);

end Struct;

