library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

entity IP_MANAGER is
	port(	
            clk, rst      	: in std_logic;		
            data_in         : out std_logic_vector (DATA_WIDTH-1 downto 0);
            data_out        : in std_logic_vector (DATA_WIDTH-1 downto 0);            
            add             : out std_logic_vector(ADD_WIDTH-1 downto 0);
            W_enable        : out std_logic;
            R_enable        : out std_logic;
            generic_en      : out std_logic;
            interrupt       : out std_logic;
        
            row_0           : in std_logic_vector (DATA_WIDTH-1 downto 0); 
            
            data_in_IPs     : in data_array; 
            data_out_IPs    : out data_array;                                         
            add_IPs         : in add_array;
            W_enable_IPs    : in std_logic_vector(NUM_IPS-1 downto 0);    
            R_enable_IPs    : in std_logic_vector(NUM_IPS-1 downto 0);                
            generic_en_IPs  : in std_logic_vector(NUM_IPS-1 downto 0);    
            enable_IPs      : out std_logic_vector(NUM_IPS-1 downto 0);    
            ack_IPs         : out std_logic_vector(NUM_IPS-1 downto 0);    
            interrupt_IPs   : in std_logic_vector(NUM_IPS-1 downto 0)         	
			);
end entity IP_MANAGER;

architecture BEHAVIOURAL of IP_MANAGER is

signal state_of_interrupt   : std_logic;
signal addr_interr          : std_logic_vector(11 downto 0);

begin

	-- PROC_1 manages the normal behavior of the IPMANAGER.
	PROC_1: process (clk, rst)
	begin  -- process Clk
		if Rst = '0' then                   			-- asynchronous reset (active low)
			data_in			<= (others => '0');
			data_out_IPs	<= (others => ((others => '0')));
			add 			<= (others => '0');
			W_enable 		<= '0';
			R_enable 		<= '0';
			generic_en 		<= '0';
			enable_IPs 		<= (others => '0');
			ack_IPs			<= (others => '0');
			state_of_interrupt <= '0';
		
		elsif Clk'event and Clk = '1' then  						-- rising clock edge
		
			-- NOT configuration mode:
			if row_0(11 downto 0) /= "000000000000" then	
			
			    enable_IPs 		<= (others => '0'); -- Needed to assure that only one IPs is enable at the time
				-- begin transaction:
				if row_0(12) = '1' then											
					enable_IPs(conv_integer(row_0(11 downto 0))-1)		<= '1';
					data_in 											<= data_in_IPs(conv_integer(row_0(11 downto 0))-1);
					data_out_IPs(conv_integer(row_0(11 downto 0))-1)    <= data_out ;
					add 												<= add_IPs(conv_integer(row_0(11 downto 0))-1);
					W_enable 											<= W_enable_IPs(conv_integer(row_0(11 downto 0))-1);
					R_enable 											<= R_enable_IPs(conv_integer(row_0(11 downto 0))-1);
					generic_en 											<= generic_en_IPs(conv_integer(row_0(11 downto 0))-1);
					
					-- Interrupt mode:
					if row_0(13) = '1' then		
						interrupt										<= '0';
						ack_IPs(conv_integer(addr_interr)) 				<= '1';
					end if;
					
				-- end transaction:
				else																				
					enable_IPs                                  		<= (others => '0');
					data_in											 	<= (others => '0');
					data_out_IPs                                        <= (others => ((others => '0')));
					add    											 	<= (others => '0');
					W_enable 											<= '0';
					R_enable 											<= '0';
					generic_en											<= '0';
					
					-- Interrupt mode
					if row_0(13) = '1' then		
						state_of_interrupt								<= '0'; -- unset the state of 'interrupt request pending'
					--end if;
					elsif (state_of_interrupt='1') then 
					   	add    									<= (others => '0');
                        data_in                                 <= row_0(DATA_WIDTH-1 downto 12) & addr_interr;
                        W_enable                                <= '1';
                        R_enable                                <= '0';
                        generic_en                              <= '1';
                    end if;
				end if;
					
			-- configuration mode:
			else																					
				
			end if;

		end if;
	end process PROC_1;
	
	
	-- PROC_2 is devoted to handle the interrupt
	PROC_2: process (clk, rst)
	begin  -- process Clk
		if Rst = '0' then                   						-- asynchronous reset (active low)
			state_of_interrupt										<= '0';	
		elsif Clk'event and Clk = '1' then  						-- rising clock edge	
			if(state_of_interrupt='1') then								-- if there is 'interrupt request pending'
				if(interrupt_IPs(conv_integer(addr_interr)) = '0') then -- if the IP clear his interrupt signal
					ack_IPs(conv_integer(addr_interr)) 							<= '0';
				end if;
			else																					-- if there isn't 'interrupt request pending'
				for I in (NUM_IPS-1) downto 0 loop								-- scan from the lower priority IP to the higher (this avoid to insert a break statement, that is not synthesizable)
						if (interrupt_IPs(I) = '1' and row_0(12) = '0') then	-- check if it rises the interrupt signal and the transaction with the Master is ended
--							interrupt								<= '1';
							--row_0(11 downto 0)						<= conv_std_logic_vector(I, 12);
--							add    									<= (others => '0');
--							data_in                                 <= row_0(DATA_WIDTH-1 downto 12) & conv_std_logic_vector(I+1, 12);
--							W_enable 								<= '1';
--                            R_enable                                <= '0';
--                            generic_en                              <= '1';
                            
							addr_interr								<= conv_std_logic_vector(I+1, 12);	--save the address of the IP
							state_of_interrupt						<= '1';	-- set the state of 'interrupt request pending'; go to PROC_1: begin-> Interrupt mode
						end if;
				end loop;
				
			end if;
		end if;
	end process PROC_2;

end architecture;
