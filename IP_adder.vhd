library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

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

	signal OP1,OP2 : 	std_logic_vector(DATA_WIDTH-1 downto 0) 	:= (others => '0');
	type state_type is (INIT, READ_OPERAND1, READ_OPERAND2, WRITE_RESULT );
    signal fsm_state: state_type;
    
begin

	proc_fsm : process(clk,rst,enable) 
	begin
		if rst = '1' then
			-- asynchronous reset:
			OP1 		<= (others => '0');
			OP2         <= (others => '0');
			address		<= (others => '0'); 
			W_enable 	<= '0';
			R_enable 	<= '0';
			generic_en 	<= '0';
			interrupt 	<= '0';
			fsm_state 	<= INIT;
		elsif (clk'event and clk = '1') then
            if  enable = '1' then
                case fsm_state is
					when INIT =>
						OP1				<= (others => '0');
						OP2				<= (others => '0');
						address			<= (others => '0'); 
						W_enable		<= '0';
						R_enable		<= '0';
						generic_en		<= '0';
						interrupt		<= '0';
						fsm_state		<= READ_OPERAND1;
					when READ_OPERAND1 =>    
						-- Reading the first operand present in row 1. 
						-- The Data Buffer is asynchronous so hopefully the assignment of the address and the read of the related data can be within the clock cycles
						address		<= conv_std_logic_vector(1, ADD_WIDTH); --address of the first operand
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt	<= '0';
						OP1			<= data_out;
						fsm_state 	<= READ_OPERAND2; 
						
					when READ_OPERAND2 => 
						-- Reading the second operand present in row 2. 
						address		<= conv_std_logic_vector(2, ADD_WIDTH); --address of the second operand
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt	<= '0';
						OP2			<= data_out;
						fsm_state 	<= WRITE_RESULT;  
	
					when WRITE_RESULT => 
						-- Store the result in row 3
						address		<= conv_std_logic_vector(3, ADD_WIDTH); --address of the second operand
						R_enable 	<= '0';
						W_enable 	<= '1';
						generic_en 	<= '1';
						interrupt	<= '0';
						fsm_state 	<= INIT;
					when OTHERS =>
						OP1				<= (others => '0');
						OP2				<= (others => '0');
						address			<= (others => '0'); 						
						R_enable 	<= '0';
						W_enable 	<= '0';
						generic_en 	<= '0';
						interrupt	<= '0';					
						fsm_state <= INIT;
                end case;
            elsif enable = '0' then 
            	OP1				<= (others => '0');
		        OP2				<= (others => '0');
		        address			<= (others => '0'); 
		        W_enable		<= '0';
		        R_enable		<= '0';
		        generic_en		<= '0';
		        interrupt		<= '0';
                fsm_state <= INIT;
            end if;
		end if;
	end process;
	
	--ADDER: Can be changed with a structural adder                  
	data_in <= OP1 + OP2;
        
end architecture BEHAVIOURAL;
