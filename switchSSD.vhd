----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:12:57 01/23/2016 
-- Design Name: 
-- Module Name:    displaySignalsSwitch - Behavioral 
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

entity displaySignalsSwitch is
    Port ( 
	        clk_100MHz: IN  std_logic;
	        bt_center: IN  std_logic;
	        a_in : in  STD_LOGIC_VECTOR (15 downto 0);
           b_in : in  STD_LOGIC_VECTOR (15 downto 0);
           c_in : in  STD_LOGIC_VECTOR (15 downto 0);
           d_in : in  STD_LOGIC_VECTOR (15 downto 0);
           --sel : in  STD_LOGIC_VECTOR (1 downto 0);
           rout : out  STD_LOGIC_VECTOR (15 downto 0));

end displaySignalsSwitch;

architecture Behavioral of displaySignalsSwitch is

	COMPONENT debouncer
	PORT(
		pb : IN std_logic;
		clock_100Hz : IN std_logic;          
		pb_debounced : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT clkGenerator
	PORT(
		clk_in : IN std_logic;          
		clk_ms : OUT std_logic;
		clk_10ms : OUT std_logic;
		clk_100ms : OUT std_logic;
		clk_s : OUT std_logic
		);
	END COMPONENT;
	
	signal clock_10ms: std_logic:='0';
	signal pb_debounced : std_logic:='0';
	signal moden : std_logic_vector(1 downto 0):="00";

begin
	
   Inst_clkGenerator: clkGenerator PORT MAP(
		clk_in => clk_100MHz,
		--clk_ms => ,
		clk_10ms => clock_10ms
		--clk_100ms => ,
		--clk_s => 
	);


   Inst_debouncer: debouncer PORT MAP(
		pb => bt_center,
		clock_100Hz => clock_10ms,
		pb_debounced => pb_debounced 
	);
process(pb_debounced)
begin
	if  (pb_debounced'EVENT) and (pb_debounced = '1')then
	moden<= std_logic_vector(unsigned(moden)+1);
	end if;
	
	case moden is
	   when "00" =>   rout <= a_in ;
		when "01" =>   rout <= b_in ;
		when "10" =>   rout <= c_in ;
		when others => rout <= d_in ;
   end case;
end process;			

end Behavioral;

