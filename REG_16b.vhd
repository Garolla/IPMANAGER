
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



library work;
use work.CONSTANTS.ALL;


entity REG_16b is
	
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
	
end REG_16b;

architecture Behavioral of REG_16b is

signal storage      : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal data_out_cpu : std_logic_vector(DATA_WIDTH - 1 downto 0);


begin

--Write Process
 process(rst, Chosen_cpu,data_cpu, data_ip_in, Write_enable_cpu, Chosen_ip, Write_enable_ip)	
 begin
 
  
    if (rst = '1')then
	    storage <= (others => '0');
		else
	  if (Chosen_cpu = '1' and Write_enable_cpu = '1') then
			 storage <= data_cpu;
		elsif(Chosen_ip = '1' and Write_enable_ip = '1')then
		     storage <= data_ip_in;
	  end if;
    end if;
  
 
 end process;

--Tristate Buffer Control for data_cpu
 

  data_cpu <= data_out_cpu when(Chosen_cpu = '1' and Read_enable_cpu = '1' and Write_enable_cpu = '0') else (others => 'Z'); 

 
--Read Process

 process(storage, Chosen_cpu, Chosen_ip, Read_enable_cpu, Read_enable_ip, Write_enable_cpu, Write_enable_ip)
 begin
 
-- if reset
	
  if (Storage = "0000000000000000") then
	data_out_cpu <= (others => '0');
  end if;  
	
	
  if(Chosen_cpu = '1' and Read_enable_cpu = '1' and Write_enable_cpu = '0')then
	 data_out_cpu <= storage;
	 data_ip_out <= (others => 'Z');
 	 else 
   if(Chosen_ip = '1' and Read_enable_ip = '1' and Write_enable_ip = '0')then
	   data_ip_out  <= storage;
	   data_out_cpu <= (others => 'Z');
	 else
	  data_ip_out  <= (others => 'Z');
	  data_out_cpu <= (others => 'Z'); 		
	end if;
  end if;
 
 
 end process;


end Behavioral;




