
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.CONSTANTS.ALL;

entity regs8_port_map is
	
	port(
			rst			         : IN  std_logic;
			data_cpu					: INOUT std_logic_vector(DATA_WIDTH - 1 downto 0);
			from_cpu_dec			: IN std_logic_vector(0 to 7);
			WE_CPU					: IN std_logic;
			RE_CPU					: IN std_logic;
			data_ip_input	      : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
			data_ip_output	      : OUT std_logic_vector(DATA_WIDTH - 1 downto 0);	
			from_ip_dec		      : IN std_logic_vector(0 to 7);
			WE_IP						: IN std_logic;
			RE_IP						: IN std_logic
	
	);


end regs8_port_map;

architecture Struct of regs8_port_map is

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

begin



regs_0 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(0),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(0),
									  WE_IP,
									  RE_IP
                  );


regs_1 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(1),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(1),
									  WE_IP,
									  RE_IP
                  );


regs_2 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(2),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(2),
									  WE_IP,
									  RE_IP
                  );


regs_3 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(3),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(3),
									  WE_IP,
									  RE_IP
                  );

regs_4 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(4),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(4),
									  WE_IP,
									  RE_IP
                  );

regs_5 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(5),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(5),
									  WE_IP,
									  RE_IP
                  );

regs_6 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(6),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(6),
									  WE_IP,
									  RE_IP
                  );


regs_7 : REG_16b port map(
                             rst,
									  
									  
									  --CPU side
									  data_cpu,
									  from_cpu_dec(7),
									  WE_CPU,
									  RE_CPU,
									  
									  --IP core side
									  data_ip_input,
									  data_ip_output,
									  from_ip_dec(7),
									  WE_IP,
									  RE_IP
                  );

end Struct;

