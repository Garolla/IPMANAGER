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
            W_enable_IPs    : in std_logic_vector(0 to NUM_IPS-1);    
            R_enable_IPs    : in std_logic_vector(0 to NUM_IPS-1);                
            generic_en_IPs  : in std_logic_vector(0 to NUM_IPS-1);    
            enable_IPs      : out std_logic_vector(0 to NUM_IPS-1);    
            ack_IPs         : out std_logic_vector(0 to NUM_IPS-1);    
            interrupt_IPs   : in std_logic_vector(0 to NUM_IPS-1)         	
			);
end entity IP_MANAGER;

architecture BEHAVIOURAL of IP_MANAGER is

begin

	-- PROC_1 manages the behavior of the IPMANAGER.
	PROC_1: process (clk, rst)
	begin  -- process Clk
		if Rst = '1' then                   			-- asynchronous reset (active high)
			data_in			<= (others => '0');
			data_out_IPs	<= (others => ((others => '0')));
			add 			<= (others => '0');
			W_enable 		<= '0';
			R_enable 		<= '0';
			generic_en 		<= '0';
			enable_IPs 		<= (others => '0');
			ack_IPs			<= (others => '0');
			interrupt       <= '0';
		
		elsif Clk'event and Clk = '1' then  						-- rising clock edge
		
			-- NOT configuration mode:
			if (conv_integer(row_0(IPADD_POS downto 0)) /= 0 ) then	
			
			    -- Assuring that only one IPs is enable in case the cpu decides to change the IP core without properly ending the transaction
			    enable_IPs 		<= (others => '0'); 
				data_in			<= (others => '0');
                data_out_IPs    <= (others => ((others => '0')));
                add             <= (others => '0');
                W_enable        <= '0';
                R_enable        <= '0';
                generic_en      <= '0';
                ack_IPs			<= (others => '0');
                
                -- Releasing interrupt:
                if (row_0(INT_POS) = '1' AND row_0(BE_POS) = '1' )then        
                    interrupt                                               <= '0';
                    ack_IPs(conv_integer(row_0(IPADD_POS downto 0))-1)      <= '1';
                end if;
                
				-- Begin ( or continue ) transaction:
				if row_0(BE_POS) = '1' then											
					enable_IPs(conv_integer(row_0(IPADD_POS downto 0))-1)	   <= '1';
					data_in 											       <= data_in_IPs(conv_integer(row_0(IPADD_POS downto 0))-1);
					data_out_IPs(conv_integer(row_0(IPADD_POS downto 0))-1)    <= data_out ;
					add 												       <= add_IPs(conv_integer(row_0(IPADD_POS downto 0))-1);
					W_enable 											       <= W_enable_IPs(conv_integer(row_0(IPADD_POS downto 0))-1);
					R_enable 											       <= R_enable_IPs(conv_integer(row_0(IPADD_POS downto 0))-1);
					generic_en 											       <= generic_en_IPs(conv_integer(row_0(IPADD_POS downto 0))-1);																		
			    
			    -- Interrupt mode:
			    -- If some IPs raise the interrupt and there is no current transaction
			    elsif (row_0(BE_POS) = '0' and conv_integer(interrupt_IPs) /= 0 ) then	
                    for I in (NUM_IPS-1) downto 0 loop            -- scan from the lower priority IP to the higher (this avoid to insert a break statement, that is not synthesizable)
                        if (interrupt_IPs(I) = '1') then    -- check if it rises the interrupt signal and the transaction with the Master is ended
                            --Write in row_0 the address of the ip with the highest priority
                            add                                     <= (others => '0');
                            data_in                                 <= row_0(DATA_WIDTH-1 downto 12) & conv_std_logic_vector(I+1, IPADD_POS+1);
                            W_enable                                <= '1';
                            R_enable                                <= '0';
                            generic_en                              <= '1';
                            -- Signal the cpu that one interrupt request must be served
                            interrupt                               <= '1';
                        end if;
                    end loop;
            
				end if;
			
			---- TODO : Future feature 		
			---- Manager configuration mode:
			-- else																					
				
			end if;

		end if;
	end process PROC_1;
	
end architecture;