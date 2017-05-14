--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:57:55 04/28/2017
-- Design Name:   
-- Module Name:   C:/Users/VHDLlocation/data_buffer/tb_data_buffer.vhd
-- Project Name:  data_buffer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_buffer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_data_buffer IS
END tb_data_buffer;
 
ARCHITECTURE behavior OF tb_data_buffer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_buffer
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         ROW_0 : OUT  std_logic_vector(15 downto 0);
         data_cpu : INOUT  std_logic_vector(15 downto 0);
         address_cpu : IN  std_logic_vector(5 downto 0);
         WE_CPU : IN  std_logic;
         RE_CPU : IN  std_logic;
         GE_CPU : IN  std_logic;
         data_ip : INOUT  std_logic_vector(15 downto 0);
         address_ip : IN  std_logic_vector(5 downto 0);
         WE_IP : IN  std_logic;
         RE_IP : IN  std_logic;
         GE_IP : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic;
   signal clk : std_logic;
   signal address_cpu : std_logic_vector(5 downto 0);
   signal WE_CPU : std_logic;
   signal RE_CPU : std_logic;
   signal GE_CPU : std_logic;
   signal address_ip : std_logic_vector(5 downto 0);
   signal WE_IP : std_logic;
   signal RE_IP : std_logic;
   signal GE_IP : std_logic;

	--BiDirs
   signal data_cpu, data_tx_cpu, data_rx_cpu : std_logic_vector(15 downto 0);
   signal data_ip, data_tx_ip, data_rx_ip     : std_logic_vector(15 downto 0);

 	--Outputs
   signal ROW_0 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_buffer PORT MAP (
          rst => rst,
          clk => clk,
          ROW_0 => ROW_0,
          data_cpu => data_cpu,
          address_cpu => address_cpu,
          WE_CPU => WE_CPU,
          RE_CPU => RE_CPU,
          GE_CPU => GE_CPU,
          data_ip => data_ip,
          address_ip => address_ip,
          WE_IP => WE_IP,
          RE_IP => RE_IP,
          GE_IP => GE_IP
        );

-- DATA CPU Tx and Rx
	data_cpu 	<= data_tx_cpu when (WE_CPU = '1' and GE_CPU = '1' and RE_CPU = '0') else (others => 'Z');
	data_rx_cpu <= data_cpu when (WE_CPU = '0' and RE_CPU = '1' and GE_CPU = '1');
	
-- DATA IP Tx and Rx
	data_ip 	  <= data_tx_ip when (WE_IP = '1' and GE_IP = '1' and RE_IP = '0') else (others => 'Z');
	data_rx_ip <= data_ip when (WE_IP = '0' and RE_IP = '1' and GE_IP = '1');	

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      rst <= '1';                 --reset
		data_tx_cpu <= (others => '1');
		address_cpu <= "000111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
--		data_tx_ip <= "1111111100000000";
		address_ip <= "111111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for clk_period*10;
		
		rst <= '0';                 --look for reset
		data_tx_cpu <= (others => '1');
		address_cpu <= "000111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
--		data_tx_ip <= "1111111100000000";
		address_ip <= "111111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for clk_period*10;
		
	   rst <= '0';                 -- ip writes in row 15
--		data_tx_cpu <= (others => '1');
		address_cpu <= "001111";
		GE_CPU <= '0';
		WE_CPU <= '1';
		RE_CPU <= '0';
		data_tx_ip <= "1111111100000000";
		address_ip <= "001111";
		GE_IP <= '1';
		WE_IP <= '1';
		RE_IP <= '0';

		
	wait for clk_period*10;

		rst <= '0';                 -- cpu reads
--		data_cpu <= (others => '1');
		address_cpu <= "001111";
		GE_CPU <= '1';
		WE_CPU <= '0';
		RE_CPU <= '1';
	--	data_ip <= "1111111100000000";
		address_ip <= "001111";
		GE_IP <= '0';
		WE_IP <= '0';
		RE_IP <= '1';
		
		wait for clk_period*10;
		
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
		
		wait for clk_period*10;
		
		rst <= '0';                 --ip reads
		address_cpu <= "001111";
		GE_CPU <= '0';
		WE_CPU <= '0';
		RE_CPU <= '1';
		address_ip <= "011111";
		GE_IP <= '1';
		WE_IP <= '0';
		RE_IP <= '1';
		

      wait;
   end process;

END;
