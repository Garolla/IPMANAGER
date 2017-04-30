library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity DATA_BUFFER is
	port(	

		clk, rst          	: in std_logic;		
		row_0			: out std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
		--PORT_0
		data_cpu		: inout std_logic_vector (DATA_WIDTH-1 downto 0);
		address_cpu       	: in std_logic_vector(ADD_WIDTH-1 downto 0);
		WE_CPU 			: in std_logic;
		RE_CPU 			: in std_logic;
		GE_CPU			: in std_logic;
		
		--PORT_1
		data_io		  	: inout std_logic_vector (DATA_WIDTH-1 downto 0);
		address_ip     		: in std_logic_vector(ADD_WIDTH-1 downto 0);
		WE_CPU 			: in std_logic;
		RE_CPU  		: in std_logic;
		GE_CPU			: in std_logic
		);
end entity DATA_BUFFER;

architecture BEHAVIOURAL of DATA_BUFFER is
	-- 64 x 16 buffer
	type mem_type is array (0 to (2**ADD_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : mem_type;
	
begin
	--TODO

end architecture;
