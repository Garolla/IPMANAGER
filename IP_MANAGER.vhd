library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

entity IP_MANAGER is
	port(	
			clk, rst          	: in std_logic;		
			data			: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in       		: out std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable 		: out std_logic;
			R_enable 		: out std_logic;
			generic_en		: out std_logic;
			interrupt		: out std_logic;

			row_0			: in std_logic_vector (DATA_WIDTH-1 downto 0); -- First line of the buffer. Must be read constantly by the ip manager
			
			data_IPs		: inout data_array; 							-- There is one data_IP for each IP core 
			add_in_IPs     		: in add_array;
			W_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs  		: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs		: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs		: out std_logic_vector(NUM_IPS-1 downto 0)		
			);
end entity IP_MANAGER;

architecture BEHAVIOURAL of IP_MANAGER is

begin
	PROC_1: process (clk, rst)
	begin  -- process Clk
		if Rst = '0' then                   			-- asynchronous reset (active low)
		data 			<= (others => '0');
		add_in 			<= (others => '0');
		W_enable 		<= '0';
		R_enable 		<= '0';
		generic_en 		<= '0';
		enable_IPs 		<= (others => '0');
		ack_IPs			<= (others => '0');
		interrupt_IPs 	<= (others => '0');
		
		elsif Clk'event and Clk = '1' then  			-- rising clock edge
		if row_0(11 downto 0) /= "000000000000" then	-- NOT configuration mode
			if row_0(13) = '0' then						-- Normal mode
				if row_0(12) = '1' then					-- begin 
					enable_IPs(conv_integer(row_0(11 downto 0)))	<= '1';
					data 						<= data_IPs(conv_integer(row_0(11 downto 0)));
					add_in 						<= add_in_IPs(conv_integer(row_0(11 downto 0)));
					W_enable 					<= W_enable_IPs(conv_integer(row_0(11 downto 0)));
					R_enable 					<= R_enable_IPs(conv_integer(row_0(11 downto 0)));
					generic_en 					<= generic_en_IPs(conv_integer(row_0(11 downto 0)));
				else							-- end
					enable_IPs(conv_integer(row_0(11 downto 0))) 	<= '0';
					data						<= (others => '0');
					add_in						<= (others => '0');
					W_enable 					<= '0';
					R_enable 					<= '0';
					generic_en					<= '0';
				end if;
			else								-- Interrupt mode
				if row_0(12) = '1' then					-- begin 
					
				else							-- end
				
				end if;			
			end if;
		else									-- configuration mode
				
		end if;

		end if;
	end process PROC_1;

end architecture;
