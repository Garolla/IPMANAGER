library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CONSTANTS.all;

entity DATA_BUFFER is
	port(	

		--clk              : in std_logic;	 
		rst              : in std_logic;		
		row_0		     : out std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
		--PORT_0
		data_cpu	     : inout std_logic_vector (DATA_WIDTH-1 downto 0);
		address_cpu      : in std_logic_vector(ADD_WIDTH-1 downto 0);
		WE_CPU 		     : in std_logic;
		RE_CPU 		     : in std_logic;
		GE_CPU		      : in std_logic;
		
		--PORT_1

		data_in_ip	  	: in std_logic_vector (DATA_WIDTH-1 downto 0);
		data_out_ip		: out std_logic_vector (DATA_WIDTH-1 downto 0);
		address_ip     	: in std_logic_vector(ADD_WIDTH-1 downto 0);
		WE_IP 			: in std_logic;
		RE_IP  			: in std_logic;
		GE_IP			: in std_logic

		);
end entity DATA_BUFFER;

architecture BEHAVIOURAL of DATA_BUFFER is
	-- 64 x 16 buffer
	type mem_type is array (0 to (2**ADD_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : mem_type;
	signal tmp_cpu	:  std_logic_vector (DATA_WIDTH-1 downto 0);
	--signal tmp_ip	:  std_logic_vector (DATA_WIDTH-1 downto 0);
	
begin

	-- Memory Write Block
  MEM_WRITE: process (data_cpu, address_cpu, WE_CPU, GE_CPU, data_in_ip, address_ip, WE_IP, GE_IP ) begin
    if (GE_CPU = '1' and WE_CPU = '1') then
		mem(conv_integer(address_cpu)) <= data_cpu;
	elsif (GE_IP = '1' and WE_IP = '1') then
		mem(conv_integer(address_ip)) <= data_in_ip;
    end if;
  end process;

	-- Tri-State Buffer control
  data_cpu	<= tmp_cpu when (GE_CPU = '1' and RE_CPU = '1' and WE_CPU = '0') else (others=>'Z');
  --data_ip	<= tmp_ip when (GE_IP = '1' and RE_IP = '1' and WE_IP = '0') else (others=>'Z');
  
	-- Memory Read Block
	row_0 <=  mem(0);
	
  MEM_READ: process (address_cpu, GE_CPU, RE_CPU, WE_CPU, address_ip, GE_IP, RE_IP, WE_IP, mem) begin
    if (GE_CPU = '1' and RE_CPU = '1' and WE_CPU = '0') then
      tmp_cpu <= mem(conv_integer(address_cpu));
    end if;
    if (GE_IP = '1' and RE_IP = '1' and WE_IP = '0') then
      --tmp_ip <= mem(conv_integer(address_ip));
	  data_out_ip <= mem(conv_integer(address_ip));
    end if;
  end process;

end architecture;
