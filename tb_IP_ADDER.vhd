LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
library work;
use work.CONSTANTS.all;

ENTITY TB_IP_ADDER is
END TB_IP_ADDER;

architecture TEST of TB_IP_ADDER is
	
	-- inputs --
    signal clk, rst, ack, enable : std_logic := '0';
    signal data_out: std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');  
    
    -- outputs --
    signal data_in : std_logic_vector (DATA_WIDTH-1 downto 0);
    signal add : std_logic_vector(ADD_WIDTH-1 downto 0);
    signal W_enable, R_enable, generic_en, interrupt : std_logic;
    signal enable_IPs, ack_IPs : std_logic_vector(0 to NUM_IPS-1);
    
	-- clocks --
    constant clk_period : time := 10 ns;    
    
begin
    	-- clock process
        clk_process : process 
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;    
        
            
        -- test process
        test_process : process
        begin
            wait for 2 ns;
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            data_out  <= conv_std_logic_vector(6, DATA_WIDTH);   
            wait for clk_period;
            enable   <= '1';
            data_out  <= conv_std_logic_vector(7, DATA_WIDTH);   
            wait for clk_period;
            data_out  <= conv_std_logic_vector(8, DATA_WIDTH); 
            wait for clk_period;
            data_out  <= conv_std_logic_vector(9, DATA_WIDTH); 
            wait for clk_period;
            data_out  <= conv_std_logic_vector(10, DATA_WIDTH); 
                        enable   <= '0';      
            wait for clk_period;
            data_out  <= conv_std_logic_vector(11, DATA_WIDTH);                                                   	
            wait;
        end process;

        DUT: entity work.IP_ADDER(BEHAVIOURAL) port map (
            clk, rst, data_in, data_out, add, W_enable, R_enable, generic_en, enable, ack, interrupt);
            		
end architecture TEST;