library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity DATA_BUFFER is
	port(	
			clk, rst          	: in std_logic;		
			data_A			  	: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in_A       		: in std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable_A 			: in std_logic;
			R_enable_A 			: in std_logic;
			generic_en_A		: in std_logic;

			row_0			  	: out std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
			data_B			  	: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in_B       		: in std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable_B 			: in std_logic;
			R_enable_B  		: in std_logic;
			generic_en_B		: in std_logic
			);
end entity DATA_BUFFER;

architecture BEHAVIOURAL of DATA_BUFFER is
	-- 64 x 16 buffer
	type mem_type is array (0 to (2**ADD_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : mem_type;
	
begin
	--TODO

end architecture;