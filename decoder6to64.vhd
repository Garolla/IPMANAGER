----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:25:38 04/25/2017 
-- Design Name: 
-- Module Name:    decoder6to64 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder6to64 is

	port(
			address 		   : IN  std_logic_vector(5 downto 0);
			generic_enable : IN  std_logic;
			Z              : OUT std_logic_vector(0 to 63)
	);

end decoder6to64;

architecture Struct of decoder6to64 is
 
 component en_decoder3to8 is
  port(
		 A 	  : IN  std_logic_vector(2 downto 0);
		 enable : IN  std_logic;
		 Y      : OUT std_logic_vector(0 to 7)
	
	); 
 end component;
 
 signal R : std_logic_vector(0 to 7);

begin
dec1 : en_decoder3to8 port map(address(5 downto 3), generic_enable, R);
dec2 : en_decoder3to8 port map(address(2 downto 0),R(0),Z(0 to 7));
dec3 : en_decoder3to8 port map(address(2 downto 0),R(1),Z(8 to 15));
dec4 : en_decoder3to8 port map(address(2 downto 0),R(2),Z(16 to 23));
dec5 : en_decoder3to8 port map(address(2 downto 0),R(3),Z(24 to 31));
dec6 : en_decoder3to8 port map(address(2 downto 0),R(4),Z(32 to 39));
dec7 : en_decoder3to8 port map(address(2 downto 0),R(5),Z(40 to 47));
dec8 : en_decoder3to8 port map(address(2 downto 0),R(6),Z(48 to 55));
dec9 : en_decoder3to8 port map(address(2 downto 0),R(7),Z(56 to 63));

end Struct;

