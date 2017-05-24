
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.CONSTANTS.ALL; 
 
ENTITY tb_data_buffer IS
END tb_data_buffer;
 
ARCHITECTURE behavior OF tb_data_buffer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_buffer
    port(
	    
		 rst			 	 : IN    std_logic;
		 ROW_0      	 : OUT   std_logic_vector(DATA_WIDTH - 1 downto 0);
       
		 --PORT_0
		 data_cpu    	 : INOUT std_logic_vector(DATA_WIDTH - 1 downto 0);
	    address_cpu 	 : IN    std_logic_vector(ADD_WIDTH - 1 downto 0);
		 WE_CPU         : IN 	std_logic;
		 RE_CPU         : IN 	std_logic;
		 GE_CPU         : IN 	std_logic;
		 
		 --PORT_1
		 data_in_ip     : IN  std_logic_vector(DATA_WIDTH - 1 downto 0);
		 data_out_ip	 : OUT std_logic_vector(DATA_WIDTH - 1 downto 0);
       address_ip  	 : IN  std_logic_vector(ADD_WIDTH - 1 downto 0);
		 WE_IP       	 : IN 	std_logic;
		 RE_IP       	 : IN 	std_logic;
		 GE_IP       	 : IN 	std_logic
	);
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic;
   signal address_cpu : std_logic_vector(ADD_WIDTH - 1 downto 0);
   signal WE_CPU : std_logic;
   signal RE_CPU : std_logic;
   signal GE_CPU : std_logic;
   signal address_ip : std_logic_vector(ADD_WIDTH - 1 downto 0);
   signal WE_IP : std_logic;
   signal RE_IP : std_logic;
   signal GE_IP : std_logic;
	signal data_in_ip : std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	
	--BiDirs
   signal data_cpu, data_tx_cpu, data_rx_cpu : std_logic_vector(DATA_WIDTH - 1 downto 0);


 	--Outputs
   signal ROW_0 			 : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal data_out_ip	 : std_logic_vector(DATA_WIDTH - 1 downto 0);
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_buffer PORT MAP (
          rst => rst,
          ROW_0 => ROW_0,
          data_cpu => data_cpu,
          address_cpu => address_cpu,
          WE_CPU => WE_CPU,
          RE_CPU => RE_CPU,
          GE_CPU => GE_CPU,
          data_in_ip => data_in_ip,
			 data_out_ip => data_out_ip,
          address_ip => address_ip,
          WE_IP => WE_IP,
          RE_IP => RE_IP,
          GE_IP => GE_IP
        );

-- DATA CPU Tx and Rx
	data_cpu 	<= data_tx_cpu when (WE_CPU = '1' and GE_CPU = '1' and RE_CPU = '0') else (others => 'Z');
	data_rx_cpu <= data_cpu when (WE_CPU = '0' and RE_CPU = '1' and GE_CPU = '1');
	
	 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
   
      rst <= '1';                 --reset
		data_tx_cpu <= (others => '1');
		address_cpu <= "000111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
		address_ip <= "111111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for 100ns;
		
		rst <= '0';                 --look for reset
		data_tx_cpu <= (others => '1');
		address_cpu <= "000111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
		address_ip <= "111111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for 100ns;
		
	   rst <= '0';                 -- ip writes in row 15
		address_cpu <= "001111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
		data_in_ip <= "1111111100000000";
		address_ip <= "001111";
		GE_IP <= '1';
		WE_IP <= '1';
		RE_IP <= '0';

		
	wait for 100ns;

		rst <= '0';                 -- cpu reads

		address_cpu <= "001111";
		GE_CPU <= '1';
		WE_CPU <= '0';
		RE_CPU <= '1';
		address_ip <= "001111";
		GE_IP <= '0';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for 100ns;
		
		rst <= '0';                 --cpu writes 
		data_tx_cpu <= "1010101010101010";
		address_cpu <= "011111";
		GE_CPU <= '1';
		WE_CPU <= '1';
		RE_CPU <= '0';
		address_ip <= "000001";
		GE_IP <= '0';
		WE_IP <= '1';
		RE_IP <= '0';
		
		wait for 100ns;
		
		rst <= '0';                 --ip reads
		address_cpu <= "001111";
		GE_CPU <= '0';
		WE_CPU <= '0';
		RE_CPU <= '1';
		address_ip <= "011111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for 100ns;
		
		rst <= '0';                 --ip reads
		address_cpu <= "001111";
		GE_CPU <= '0';
		WE_CPU <= '0';
		RE_CPU <= '1';
		address_ip <= "000000";
		GE_IP <= '1';
		WE_IP <= '1';
		RE_IP <= '0';
		data_in_ip <= "1111111100000111";

		wait for 100ns;

		rst <= '0';                 --ip reads
		address_cpu <= "000000";
		GE_CPU <= '1';
		WE_CPU <= '0';
		RE_CPU <= '1';
		address_ip <= "000000";
		GE_IP <= '0';
		WE_IP <= '0';
		RE_IP <= '1';
		

      wait;
   end process;

END;
