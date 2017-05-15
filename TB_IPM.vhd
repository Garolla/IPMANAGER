LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TB_IPM is
END TB_IPM;

architecture beh of TB_IPM is

	component IP_MANAGER 
		port(	
			clk, rst      	: in std_logic;		
			data				: inout std_logic_vector (DATA_WIDTH-1 downto 0);
			add_in     		: out std_logic_vector(ADD_WIDTH-1 downto 0);
			W_enable 		: out std_logic;
			R_enable 		: out std_logic;
			generic_en		: out std_logic;
			interrupt		: out std_logic;

			row_0				: inout std_logic_vector (DATA_WIDTH-1 downto 0); 
			
			data_IPs			: inout data_array; 							
			add_in_IPs 		: in add_array;
			W_enable_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
			R_enable_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);				
			generic_en_IPs	: in std_logic_vector(NUM_IPS-1 downto 0);	
			enable_IPs		: out std_logic_vector(NUM_IPS-1 downto 0);	
			ack_IPs			: out std_logic_vector(NUM_IPS-1 downto 0);	
			interrupt_IPs	: in std_logic_vector(NUM_IPS-1 downto 0)		
			);
	end component;
	
	-- inputs --
	signal clk, reset : std_logic := '0';
	---- (TODO: change these to data in when the component is ready) ----
	signal data, row_0 : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal data_IPs, add_in_IP: data_array;
	signal W_enable_IPs, R_enable_IPs, generic_en_IPs, interrupt_IPs : std_logic_vector(NUM_IPS-1 downto 0);

	-- outputs --
	---- (TODO: data out for buffer and IPs) ----
	signal add_in : std_logic_vector(ADD_WIDTH-1 downto 0);
	signal W_enable, R_enable, generic_en, interrupt : std_logic;
	signal enable_IPs, ack_IPs : std_logic_vector(NUM_IPS-1 downto 0);

	-- clocks --
	constant clk_period : time := 6 ns;

begin

	-- UUT
	UUT : IP_MANAGER port map (
			clk, rst, data, add_in, W_enable, R_enable, generic_en, interrupt, 
			row_0,
			data_IPs, add_in_IPs, W_enable_IPs, R_enable_IPs, generic_en_IPs, enable_IPs, ack_IPs, interrupt_IPs
	);

	-- clock process
	clk_process : process 
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;	
	
	-- TODO: test process
end;
