----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:55:47 10/30/2015 
-- Design Name: 
-- Module Name:    sixteen2Four - Behavioral 
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

entity MUX16to4 is
    Port ( x : in  STD_LOGIC_VECTOR (15 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           Sout : out  STD_LOGIC_VECTOR (3 downto 0));
end MUX16to4;

architecture Behavioral of MUX16to4 is

begin

 process(x,Sel)
 begin
 case Sel is
 when "00" =>
 Sout <= x(3 downto 0);
 when "01" =>
 Sout <= x(7 downto 4);
 when "10" =>
 Sout <= x(11 downto 8);
 when others =>
 Sout <= x(15 downto 12);
 end case;
 end process;

end Behavioral;

