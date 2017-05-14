----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:13 04/26/2017 
-- Design Name: 
-- Module Name:    REG_16b - Behavioral 
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

entity REG_16b is
	
	port(
			rst			         : IN     std_logic;
			clk			         : IN     std_logic;
			
			-- CPU side
			data_cpu             : INOUT  std_logic_vector (15 downto 0);
			Chosen_cpu    		   : IN  	std_logic;
			Write_enable_cpu     : IN  	std_logic;
			Read_enable_cpu      : IN  	std_logic;
			
			-- IP core side
			data_ip_in           : IN	   std_logic_vector (15 downto 0);
			data_ip_out          : OUT	   std_logic_vector (15 downto 0);
			Chosen_ip 		      : IN     std_logic;
			Write_enable_ip      : IN     std_logic;
			Read_enable_ip       : IN     std_logic
	);
	
end REG_16b;

architecture Behavioral of REG_16b is

signal storage      : std_logic_vector(15 downto 0);
signal data_out_cpu : std_logic_vector(15 downto 0);


begin

--Write Process
 process(clk)	
 begin
 
  if (clk = '1' and clk'EVENT ) then
    if (rst = '1')then
	    storage <= (others => '0');
		else
	  if (Chosen_cpu = '1' and Write_enable_cpu = '1') then
			 storage <= data_cpu;
		else
		 if(Chosen_ip = '1' and Write_enable_ip = '1')then
			  storage <= data_ip_in;
	    end if;
	  end if;
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




