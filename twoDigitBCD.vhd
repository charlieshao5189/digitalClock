----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:33:10 03/10/2015 
-- Design Name: 
-- Module Name:    twoDigitBCD - Behavioral 
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- convert two digit number to two digit bcd value
entity twoDigitBCD is
    Port ( binNumber : in  STD_LOGIC_VECTOR (6 downto 0);--input two digit number 00-99, binary format
           tenths_ones : out  STD_LOGIC_VECTOR (7 downto 0));--output bcd values of two digit
end twoDigitBCD;

architecture Behavioral of twoDigitBCD is
begin
		bin2BCD : process(binNumber)          
		variable temp: std_logic_vector(6 downto 0); -- used for buffer during caculate
		variable BCD: std_logic_vector(7 downto 0) := (others => '0'); --four bits for TENTHS and four bits for ONES
		begin
		BCD := (others => '0');
		temp (6 downto 0) := binNumber;-- give binNumber to temp
		for i in 0 to 6 loop         --loop 7 times
				if unsigned(BCD(3 downto 0)) > 4 then 
						BCD(3 downto 0) := std_logic_vector(unsigned(BCD(3 downto 0)) + 3);
				end if;  
				if unsigned(BCD(7 downto 4)) > 4 then
						BCD(7 downto 4) := std_logic_vector(unsigned(BCD(7 downto 4)) + 3);
				end if;
-------------------------------------------------------------------------------------------
				-- Shift BCD left by 1 bit:
				BCD(7 downto 1) := BCD(6 downto 0);
				BCD(0) := temp(6);
				temp(6 downto 1) := temp(5 downto 0);
		end loop;
		tenths_ones <= BCD(7 downto 0);
end process;
end Behavioral;