library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

entity IP_DUMMY is 
	port (
		clk, rst	: 	in 	std_logic;

		data_in		: 	out	std_logic_vector(DATA_WIDTH-1 downto 0);
		data_out	: 	in	std_logic_vector(DATA_WIDTH-1 downto 0);
		address		: 	out std_logic_vector(ADD_WIDTH-1 downto 0);

		W_enable	:	out std_logic;
		R_enable	: 	out std_logic;
		generic_en	: 	out std_logic;

		enable		: 	in 	std_logic;		

		ack			: 	in 	std_logic;
		interrupt	:	out std_logic
	);
end entity IP_DUMMY;

architecture BEHAVIOURAL of IP_DUMMY is 
    
begin
            
    address			<= conv_std_logic_vector(4, ADD_WIDTH);        
    data_in 		<= conv_std_logic_vector(666, DATA_WIDTH);       
   	W_enable   		<= '1';
   	R_enable		<= '0';
   	generic_en		<= '1';
   	interrupt		<= '0';
   	
end architecture BEHAVIOURAL;
