library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

--&&&&&&&&&&&&&&&&&&&&&&&&& Behaviour of the IP ADDER &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--Initialized to read row1 (where the CPU writes the first operand)
--One clock cylce after the enable is 1, we ask to read row2 (where the CPU writes the second operand)
--1 cc after, we receive the first operand that is stored
--1 cc after, we receive the second operand that can be added to the first one and sent to the IP manager
--1 cc after, the IP ADDER stops and the result is written in row3

entity IP_ADDER is 
	port (
		clk, rst	: 	in 	std_logic;

		data_in		: 	out	std_logic_vector(DATA_WIDTH-1 downto 0);
		data_out	: 	in std_logic_vector(DATA_WIDTH-1 downto 0);
		address		: 	out std_logic_vector(ADD_WIDTH-1 downto 0);

		W_enable	:	out std_logic;
		R_enable	: 	out std_logic;
		generic_en	: 	out std_logic;

		enable		: 	in 	std_logic;		

		ack			: 	in 	std_logic;
		interrupt	:	out std_logic
	);
end entity IP_ADDER;

architecture BEHAVIOURAL of IP_ADDER is 

	signal OP1 : 	std_logic_vector(DATA_WIDTH-1 downto 0) 	:= (others => '0');
	type state_type is (READ_OPERAND2, WRITE_OPERAND1, WRITE_RESULT, IDLE );
    signal fsm_state: state_type;
    
begin

	proc_fsm : process(clk,rst,enable) 
	begin
		if rst = '1' then
			-- asynchronous reset.
			--In idle always ask to read the first operand
			OP1 		<= (others => '0');
			data_in     <= (others => '0');
			address		<= conv_std_logic_vector(1, ADD_WIDTH); 
			R_enable 	<= '1';
			W_enable 	<= '0';
			generic_en 	<= '1';
			interrupt 	<= '0';
			fsm_state 	<= READ_OPERAND2;
		elsif (clk'event and clk = '0') then -- Working on falling edge
            if  enable = '1' then
                case fsm_state is
					when READ_OPERAND2 =>    
						-- Asking for the second operand, present in row 2 and 
						address		<= conv_std_logic_vector(2, ADD_WIDTH); --address of the second operand
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt	<= '0';
						fsm_state 	<= WRITE_OPERAND1; 				
						
					when WRITE_OPERAND1 => 
						--Since there is a latency of 1 clock cycle from the read request now we can write OP1 the first operand. 
						--The reading of the row 1 is done in the reset/init states so that when the IP ADDER is enabled immediately asks for the first operand
						OP1			<= data_out;
						address		<= (others => '0');
						R_enable 	<= '0';
						W_enable 	<= '0';
						generic_en 	<= '0';
						interrupt	<= '0';
						fsm_state 	<= WRITE_RESULT;  
	
					when WRITE_RESULT => 
						-- Store the result in row 3. The second operand is in data_out
						data_in		<= OP1 + data_out; --ADDER
						address		<= conv_std_logic_vector(3, ADD_WIDTH); 
						R_enable 	<= '0';
						W_enable 	<= '1';
						generic_en 	<= '1';
						interrupt	<= '0';
						fsm_state 	<= IDLE;
						
					when IDLE => 
						--In idle always ask to read the first operand
						OP1			<= (others => '0');
						data_in		<= (others => '0');
						address		<= (others => '0');
						R_enable 	<= '0';
						W_enable 	<= '0';
						generic_en 	<= '0';
						interrupt	<= '0';
						fsm_state 	<= READ_OPERAND2;						
					when OTHERS =>
						--In idle always ask to read the first operand
						OP1				<= (others => '0');
						data_in			<= (others => '0');
						address			<= conv_std_logic_vector(1, ADD_WIDTH); 						
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt	<= '0';					
						fsm_state <= READ_OPERAND2;
                end case;
            elsif enable = '0' then 
           		--In idle always ask to read the first operand
            	OP1				<= (others => '0');
            	data_in			<= (others => '0');
		        address			<= conv_std_logic_vector(1, ADD_WIDTH); 	
		        R_enable		<= '1';
		        W_enable		<= '0';
		        generic_en		<= '1';
		        interrupt		<= '0';
                fsm_state <= READ_OPERAND2;
            end if;
		end if;
	end process;
	
end architecture BEHAVIOURAL;
