----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:02:21 04/25/2017 
-- Design Name: 
-- Module Name:    en_decoder3to8 - Behavioral 
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

entity en_decoder3to8 is
	
	port(
		 A 	  : IN  std_logic_vector(2 downto 0);
		 enable : IN  std_logic;
		 Y      : OUT std_logic_vector(0 to 7)
	
	);


end en_decoder3to8;

architecture Behavioral of en_decoder3to8 is

begin
 
 process(enable , A)
  begin
   
	if (enable = '1') then
       
		    if(A = "000") then 
								Y(0)      <= '1';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '0';
							   							   
			 elsif (A = "001") then
								Y(0)      <= '0';
								Y(1)      <= '1';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '0';

          elsif (A = "010") then 
								Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '1';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '0';
			 elsif (A = "011") then
								Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '1';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '0';
			 elsif (A = "100") then
								Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '1';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '0';
			 elsif (A = "101") then 
			               Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '1';
								Y(6)      <= '0';
								Y(7)      <= '0';
			 elsif (A = "110") then
								Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '1';
								Y(7)      <= '0';
			 else
			               Y(0)      <= '0';
								Y(1)      <= '0';
								Y(2)      <= '0';
								Y(3)      <= '0';
								Y(4)      <= '0';
								Y(5)      <= '0';
								Y(6)      <= '0';
								Y(7)      <= '1';
		   
		    end if;
	  
	  else 
             Y <= (others => '0');			
	      
	end if;
 
 end process;

end Behavioral;

