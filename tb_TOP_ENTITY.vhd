LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

ENTITY TB_TOP_ENTITY is
END TB_TOP_ENTITY;

architecture TEST of TB_TOP_ENTITY is

	-- Bidirectional
	signal	data, data_tx, data_rx	  	: std_logic_vector (DATA_WIDTH-1 downto 0);
	-- Input
	signal	clock,reset		: std_logic := '0';
	signal	address    		: std_logic_vector (ADD_WIDTH-1 downto 0):= (others => '0');
	signal	W_enable		: std_logic := '0';
	signal	R_enable		: std_logic := '0';
	signal	generic_enable	: std_logic := '0';
	-- Output
	signal	interrupt		: std_logic;
	
	-- Clocks --
    constant clk_period : time := 10 ns;    
begin

	UUT: entity work.TOP_ENTITY 
		port map( clock, reset, data, address, W_enable, R_enable, generic_enable, interrupt );	
		
	-- clock process
    clk_process : process 
    begin
		clock	<=	NOT clock	after clk_period/2;
    end process;  

	-- Combinational signal necessary to handle the data inout port
	data 	<= data_tx when (W_enable = '1' and generic_enable = '1' and R_enable = '0') else (others => 'Z');
	data_rx	<= data when (W_enable = '0' and R_enable = '1' and generic_enable = '1');
	
	-- test process
	test_process : process
	begin
	    wait for 2 ns;
		reset	<= '1';
		wait for clk_period;
		reset	<= '0';
		data_tx	<=	
		
		
		
		wait;
	end process;	
		
end architecture;