LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

ENTITY TB_TOP_ENTITY is
END TB_TOP_ENTITY;

architecture TEST of TB_TOP_ENTITY is

	-- Bidirectional
	signal	data, data_tx  	: std_logic_vector (DATA_WIDTH-1 downto 0);
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

	clock	<=	NOT clock	after clk_period/2;

	-- Combinational signal necessary to handle the bidirectional data port
	data 	<= data_tx when (W_enable = '1' and generic_enable = '1' and R_enable = '0') else (others => 'Z');
	
	-- test process
	test_process : process
	begin
------------------------------------- Testing the CPU - IP_ADDER transaction -----------------------------------------------------------------------------------
	    wait for 2 ns;
		reset			<= '1';
		wait for clk_period;
---------------------------- Writing Data Buffer rows -------------------------------------------------- 
		reset			<= '0';
		address			<= conv_std_logic_vector(1, ADD_WIDTH);  	
		data_tx			<= conv_std_logic_vector(55, DATA_WIDTH);  
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';
		wait for clk_period;
		address			<= conv_std_logic_vector(1, ADD_WIDTH);  	
		data_tx			<= conv_std_logic_vector(93, DATA_WIDTH);  
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';		
		wait for clk_period;
		address			<= conv_std_logic_vector(2, ADD_WIDTH);  
		data_tx			<= conv_std_logic_vector(72, DATA_WIDTH);  	
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';				
		wait for clk_period;
		address			<= conv_std_logic_vector(3, ADD_WIDTH);  
		data_tx			<= conv_std_logic_vector(3, DATA_WIDTH); 	
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';			
		wait for clk_period;
		address			<= conv_std_logic_vector(4, ADD_WIDTH);
		data_tx			<= conv_std_logic_vector(4, DATA_WIDTH);   	
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';	
		wait for clk_period;
-------------------------------------------- Reading Data Buffer rows -------------------------------------------------- 		
		address			<= conv_std_logic_vector(4, ADD_WIDTH);
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';	
		wait for clk_period;
		data_tx			<= (others => '0');  
		address			<= conv_std_logic_vector(3, ADD_WIDTH);
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';	
		wait for clk_period;		
		address			<= conv_std_logic_vector(2, ADD_WIDTH);
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';		
		wait for clk_period;
		address			<= conv_std_logic_vector(1, ADD_WIDTH);
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';				
		wait for clk_period;
		address			<= conv_std_logic_vector(0, ADD_WIDTH);
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';				
		wait for clk_period;				
		W_enable		<= '0';
		R_enable		<= '0';
		generic_enable	<= '0';		
		wait for clk_period;	
-------------------------------------------- Starting tranasction -------------------------------------------------- 	
		--Requires 4 c.c to end it
		address			<= conv_std_logic_vector(0, ADD_WIDTH);
		data_tx			<= "0001" & conv_std_logic_vector(2, IPADD_POS+1); -- 12 bits are used for the IP number  	
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';	
		wait for clk_period;		
		W_enable		<= '0';
		R_enable		<= '0';
		generic_enable	<= '0';	
		wait for clk_period;		
		W_enable		<= '0';
		R_enable		<= '0';
		generic_enable	<= '0';	
		wait for clk_period;		
		W_enable		<= '0';
		R_enable		<= '0';
		generic_enable	<= '0';		
		wait for clk_period;	
		--Closing Transaction	
		address			<= conv_std_logic_vector(0, ADD_WIDTH);
		data_tx			<= "0000" & conv_std_logic_vector(2, IPADD_POS+1); -- 12 bits are used for the IP number  	
		W_enable		<= '1';
		R_enable		<= '0';
		generic_enable	<= '1';			
		wait for clk_period;	
		--Reading result of the sum in row 3
		address			<= conv_std_logic_vector(3, ADD_WIDTH);	
		W_enable		<= '0';
		R_enable		<= '1';
		generic_enable	<= '1';
		wait for clk_period;				
-------------------------------------------- Ending tranasction -------------------------------------------------- 	
						
		W_enable		<= '0';
		R_enable		<= '0';
		generic_enable	<= '0';	
		wait;
	end process;	
		
end architecture;