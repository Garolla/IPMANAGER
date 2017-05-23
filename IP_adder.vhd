library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity IP_adder is 
	port (
		clk, rst : 	in 	std_logic;

		data_in : 	in 	std_logic_vector(DATA_WIDTH-1 downto 0);
		data_out : 	out 	std_logic_vector(DATA_WIDTH-1 downto 0);
		add : 	out 	std_logic_vector(ADD_WIDTH-1 downto 0);

		W_enable :	out 	std_logic;
		R_enable : 	out 	std_logic;
		generic_en : 	out 	std_logic;

		enable : 	in 	std_logic;		

		ack : 	in 	std_logic;
		interrupt : out std_logic;
	);
end entity IP_adder;

architecture BEH of IP_adder is 

	signal OP1, OP2 : 	std_logic_vector(DATA_WIDTH-1 downto 0) 	:= (others => '0');
	signal fsm_state : 	std_logic_vector(2 downto 0) 	:= 	"000";

begin
	
	-- I assume that if enable = 1, 
	-- I can carry out all my read, add, and write 
	-- without interruption.

	proc_fsm : process(clk,rst) 
	begin
		if rst = '1' then
			-- synchronous reset:
			OP1 			<= (others => '0');
			OP2 			<= (others => '0');
			data_out 	<= (others => '0');
			add 			<= (others => '0');
			W_enable 	<= '0';
			R_enable 	<= '0';
			generic_en 	<= '0';
			interrupt 	<= '0';
		elsif (clk'event and clk = '1' and enable = '1') then
			-- FSM active
			if (fsm_state = "000") then
			 	-- read row 1
				add 	<= std_logic_vector(to_unsigned(1, add'length));
				R_enable 	<= '1';
				W_enable 	<= '0';
				generic_en 	<= '1';
				fsm_state 	<= "001";
			elsif (fsm_state = "001") then 
				-- try to pipeline read access. send address of row 2
				add 	<= std_logic_vector(to_unsigned(2, add'length));
				fsm_state 	<= "010";
			elsif (fsm_state = "010") then
				-- wait
				fsm_state 	<= "011";
			elsif (fsm_state = "011") then
				-- store row 1
				OP1 	<= data_in;
				fsm_state 	<= "100";
			elsif (fsm_state = "100") then
				-- compute the sum as hopefully now row 2 should be in data_out
				data_out = OP1 + data_in;
				R_enable <= '0';
				W_enable <= '1';
				fsm_state <= "101";
			else 
				-- sink state. idle until next positive edge on "enable"
				R_enable <= '0';
				W_enable <= '0';
				generic_en <= '0';
			end if;
		end if;
	end process;

	wakeup : process(enable) 
	begin
		if (enable = '1') then
			fsm_state = "000";
		end if;
	end process;

end architecture BEH;
