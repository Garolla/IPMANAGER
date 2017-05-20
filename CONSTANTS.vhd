library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package CONSTANTS is
 
	constant NUM_IPS                : integer := 4;  --- Number of IP cores that must be handled by the ip core manager
	constant DATA_WIDTH				: integer := 16;
	constant ADD_WIDTH				: integer := 6;
	
	type data_array is array (NUM_IPS - 1  downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
	type add_array	is array (NUM_IPS - 1  downto 0) of std_logic_vector(ADD_WIDTH-1 downto 0);
	
end package CONSTANTS;
