----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:34:26 01/27/2014 
-- Design Name: 
-- Module Name:    mux2to1 - arch1 
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

entity mux2to1 is
    Port ( x  : in  STD_LOGIC_VECTOR(1 downto 0);
	        --x0: in STD_LOGIC
			  --x1: in STD_LOGIC
				s  : in  STD_LOGIC;
           y : out  STD_LOGIC
			  );
end mux2to1;

architecture arch1 of mux2to1 is

begin
--	with s select
--		y <=  x1 when '0',
--				x2 when others;
--	y <= x1 when s = '0' else x2;
	y <= x(0) when s = '0' else x(1);
end arch1;

