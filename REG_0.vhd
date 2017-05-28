
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


library work;
use work.CONSTANTS.ALL;


entity REG_0 is
	
	port(
			rst			         : IN  std_logic;
	
			row_0						: OUT std_logic_vector(DATA_WIDTH - 1 downto 0);
			
			-- CPU side
			I_cpu                : INOUT  std_logic_vector(DATA_WIDTH - 1 downto 0);
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
	
end REG_0;

architecture Behavioral of REG_0 is
signal I_cpu_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal storage   : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
	
	
write_proc:	process(rst, Chosen_cpu, Write_enable_cpu, Chosen_ip, Write_enable_ip)
				begin 
						
						if (rst = '1') then
						 
						  storage <= (others => '0');
						  
						  else
						   
							if (Chosen_cpu = '1' and Write_enable_cpu = '1' and Read_enable_cpu = '0') then
							     
								 storage <= I_cpu; 
							 
							 elsif (Chosen_ip = '1' and Write_enable_ip = '1' and Read_enable_ip = '0') then
									 
									  storage <= I_ip_in;
					
						   end if;
						
						end if;
				
				end process;
				
-- The content of "storage" signal is always read by output port "row_0" .
 
	row_0 <= storage;

-- Use I_cpu as output when cpu wants to  read, so I_cpu puts in output the content of I_cpu_out.
-- I_cpu_out takes the content of storage when cpu is enabled to read. 

	I_cpu <= I_cpu_out when (Chosen_cpu = '1' and Write_enable_cpu = '0' and Read_enable_cpu = '1') else (others => 'Z');

	
 process(storage, Chosen_cpu, Chosen_ip, Read_enable_cpu, Read_enable_ip, Write_enable_cpu, Write_enable_ip)
 begin
 
-- if reset
	
  if (storage = "0000000000000000") then
	I_cpu_out <= (others => '0');
  end if;  
	
	
  if(Chosen_cpu = '1' and Read_enable_cpu = '1' and Write_enable_cpu = '0')then
	 I_cpu_out <= storage;
	 I_ip_out <= (others => 'Z');
 	 else 
   if(Chosen_ip = '1' and Read_enable_ip = '1' and Write_enable_ip = '0')then
	   I_ip_out  <= storage;
	   I_cpu_out <= (others => 'Z');
	 else
	  I_ip_out  <= (others => 'Z');
	  I_cpu_out <= (others => 'Z'); 		
	end if;
  end if;
 
 
 end process;
















end Behavioral;

