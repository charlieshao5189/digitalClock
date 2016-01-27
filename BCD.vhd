----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:55:46 10/30/2015 
-- Design Name: 
-- Module Name:    BCD - Behavioral 
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

entity BCD is
    Port ( BCD_num : in  STD_LOGIC_VECTOR (3 downto 0);
           Seg: out STD_LOGIC_VECTOR(6 downto 0)
			  );
end BCD;

architecture Behavioral of BCD is
begin
 process(BCD_num )
 begin
 case BCD_num  is
 when x"0" => --0
 seg<="1000000";
 --a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='1';
 when x"1" => --1
 seg<="1111001";
 --a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
 when x"2" => --2
 seg<="0100100";
 --a<='0';b<='0';c<='1';d<='0';e<='0';f<='1';g<='0';
 when x"3" => --3
 seg<="0110000";
 --a<='0';b<='0';c<='0';d<='0';e<='1';f<='1';g<='0';
 when x"4" => --4
 seg<="0011001";
 --a<='1';b<='0';c<='0';d<='1';e<='1';f<='0';g<='0';
 when "0101" => --5
 seg<="0010010";
 --a<='0';b<='1';c<='0';d<='0';e<='1';f<='0';g<='0';
 when "0110" => --6
 seg<="0000010";
 --a<='0';b<='1';c<='0';d<='0';e<='0';f<='0';g<='0';
 when "0111" => --7
 seg<="1111000";
 --a<='0';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
 when "1000" => --8
 seg<="0000000";
 --a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='0';
 when "1001" => --9
 seg<="0010000";
 --a<='0';b<='0';c<='0';d<='0';e<='1';f<='0';g<='0';
 when "1010" => --A
 seg<="0001000";
 --a<='0';b<='0';c<='0';d<='1';e<='0';f<='0';g<='0';
 when "1011" => --B
 seg<="0000011";
 --a<='1';b<='1';c<='0';d<='0';e<='0';f<='0';g<='0';
 when "1100" => --C
 seg<="1000110";
 --a<='0';b<='1';c<='1';d<='0';e<='0';f<='0';g<='1';
 when "1101" => --D
 seg<="0100001";
 --a<='1';b<='0';c<='0';d<='0';e<='0';f<='1';g<='0';
 when "1110" => --E
 seg<="0000110";
 --a<='0';b<='1';c<='1';d<='0';e<='0';f<='0';g<='0';
 when others => --all off
 seg<="1111111";
 --a<='0';b<='1';c<='1';d<='1';e<='0';f<='0';g<='0';
 end case;
 end process;
end Behavioral;


