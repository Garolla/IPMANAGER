----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:25:50 04/28/2017 
-- Design Name: 
-- Module Name:    REG_0 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG_0 is
	
	port(
			rst			         : IN  std_logic;
			clk			         : IN  std_logic;
			row_0						: OUT std_logic_vector(15 downto 0);
			
			-- CPU side
			I_cpu                : IN  std_logic_vector (15 downto 0);
			Chosen_cpu    		   : IN  std_logic;
			Write_enable_cpu     : IN  std_logic;
	
			
			-- IP core side
			I_ip                 : IN  std_logic_vector (15 downto 0);
			Chosen_ip 		      : IN  std_logic;
			Write_enable_ip      : IN  std_logic
	
	);
	
end REG_0;

architecture Behavioral of REG_0 is



begin
	
	
write_proc:	process(clk)
				begin 
					
					if (clk = '1' and clk'EVENT) then
						
						if (rst = '1') then
						 
						  row_0 <= (others => '0');
						  
						  else
						   
							if (Chosen_cpu = '1') then
							
							   if (Write_enable_cpu = '1') then
							     
								 row_0 <= I_cpu; 
							   
								end if;
							 
							 else
							 
							   if (Chosen_ip = '1') then
      
                            if (Write_enable_ip = '1') then
									 
									  row_0 <= I_ip;
									 
									 end if;
								
								end if;								
                   
						   end if;
						
						end if;
					
					end if;
				
				end process;
				
end Behavioral;

