library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

--&&&&&&&&&&&&&&&&&&&&&&&&& Behaviour of the IP INT-ACC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--Initialized to read row1 (where the CPU writes the first operand) and to set count to a certain number
-- When enable turns 1, continue to request to read OP1, do nothing
-- from the 2nd cc and while enable stays at 1 && count > 0, 
	-- Accumulate OP1 into RES 
	-- Ask to read the next OP1
	-- decrease count
-- When count = 0, send the interrupt and stop accumulating OP1
-- Wait until interrupt ack
-- The result is written in row3

entity IP_INTACC is 
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
end entity IP_INTACC;


architecture BEH of IP_INTACC is

	signal RES : std_logic_vector(DATA_WIDTH-1 downto 0) 	:= (others => '0');
	variable CNT: integer := 0;
	type state_type is ( OP_START, ACCUMULATE, WAIT_ACK, IDLE );
	    signal fsm_state: state_type;

begin	
	proc_fsm : process(clk,rst,enable) 
	begin
		if rst = '1' then
			-- asynchronous reset.
			--In idle always ask to read OP1
			RES 			<= (others => '0');
			data_in     <= (others => '0');
			address		<= conv_std_logic_vector(4, ADD_WIDTH); 
			R_enable 	<= '1';
			W_enable 	<= '0';
			generic_en 	<= '1';
			interrupt 	<= '0';
			fsm_state 	<= OP_START;
		elsif (clk'event and clk = '0') then -- Working on falling edge
         if  enable = '1' then
         	case fsm_state is
					when OP_START =>
						-- Just received enable; OP1 is not ready. continue to read. Initialize CNT.
						CNT := 5;
						address		<= conv_std_logic_vector(4, ADD_WIDTH); 		
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt	<= '0';
						fsm_state 	<= ACCUMULATE;				
					when ACCUMULATE =>
						-- data_out is valid, continue to read and accumulate OP1 into RES
						RES <= RES + data_out;
						CNT := CNT - 1;
						if CNT = 0 then -- can check same cycle, it's a variable (?)
							interrupt <= '1';
							fsm_state <= WAIT_ACK;
						-- else stay in ACCUMULATE state
						end if;
					when WAIT_ACK =>
						R_enable 	<= '0';
						W_enable 	<= '0';
						generic_en 	<= '0';
						if (ack = '1') then
							interrupt <= '0';
							fsm_state <= WRITE_RES;
						else 
							interrupt <= '1';
						-- and stay in WAIT_ACK state			
						end if;
					when WRITE_RES =>	
						-- store the result in row 5
						data_in		<= RES;
						address		<= conv_std_logic_vector(5, ADD_WIDTH); 
						R_enable 	<= '0';
						W_enable 	<= '1';
						generic_en 	<= '1';
						interrupt	<= '0';
						fsm_state 	<= IDLE;
					when IDLE =>
						--In idle always ask to read OP1
						RES 			<= (others => '0');
						data_in     <= (others => '0');
						address		<= conv_std_logic_vector(4, ADD_WIDTH); 
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt 	<= '0';
						fsm_state 	<= OP_START;						
					when OTHERS =>
						--In idle always ask to read OP1
						RES 			<= (others => '0');
						data_in     <= (others => '0');
						address		<= conv_std_logic_vector(4, ADD_WIDTH); 
						R_enable 	<= '1';
						W_enable 	<= '0';
						generic_en 	<= '1';
						interrupt 	<= '0';
						fsm_state 	<= OP_START;
				end case;
			elsif enable = '0' then 
				--In idle always ask to read OP1
				RES 			<= (others => '0');
				data_in     <= (others => '0');
				address		<= conv_std_logic_vector(4, ADD_WIDTH); 
				R_enable 	<= '1';
				W_enable 	<= '0';
				generic_en 	<= '1';
				interrupt 	<= '0';
				fsm_state 	<= OP_START;
			end if;
		end if;
	end process;
end architecture BEH;
