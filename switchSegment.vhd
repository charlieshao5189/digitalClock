----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:03:21 01/21/2016 
-- Design Name: 
-- Module Name:    switchSegment - Behavioral 
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

entity switchSegment is
    --Generic (Maxcount: natural := 25000); --250000£º0.01s
    --Generic (Maxcount: natural := 25); --for simulation		 
	 Port ( clk : in  STD_LOGIC;
           Selseg : out  STD_LOGIC_VECTOR (3 downto 0);
           SelBCD : out  STD_LOGIC_VECTOR (1 downto 0));
end switchSegment;

architecture Behavioral of switchSegment is

	signal clk_temp: STD_LOGIC:='0';
	signal count : natural:=0;
	signal Scount : STD_LOGIC_VECTOR(1 downto 0):="00"; 
	
begin

--process(clk)
--begin
--if(clk'event and clk='1') then
--count <=count+1;
--if(count = Maxcount) then
--clk_temp <= not clk_temp;
--count <=0;
--end if;
--end if;
--end process;

process(clk)   --period of clk is 10ms.
begin

if(clk'event and clk='1') then
case Scount is
when "00"=>
SelSeg<="1110";SelBCD<="00";
when "01"=>	
SelSeg<="1101";SelBCD<="01";
when "10"=>
SelSeg<="1011";SelBCD<="10";
when others=>
SelSeg<="0111";SelBCD<="11";
end case;
Scount<= std_logic_vector(signed(Scount)+1);
end if;
end process;

end Behavioral;
