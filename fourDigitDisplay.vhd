----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:24 01/22/2016 
-- Design Name: 
-- Module Name:    fourDigitDisplay - Behavioral 
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

entity fourDigitDisplay is
    Port ( clk_100Mhz: in  STD_LOGIC; 
           digitValue : in  STD_LOGIC_VECTOR (15 downto 0);--BCD values of four digit will be displayed
           digitDp : in  STD_LOGIC_VECTOR (3 downto 0);--control four decimal points
           an : out  STD_LOGIC_VECTOR (3 downto 0);-- choose which segment to display
           seg : out STD_LOGIC_VECTOR (6 downto 0);-- control leds on seven-segment
			  dp_led: out STD_LOGIC                   -- control decimal point
			  );		  
end fourDigitDisplay;

architecture Behavioral of fourDigitDisplay is

COMPONENT clkGenerator
	PORT(
		clk_in : IN std_logic;          
		clk_1KHz : OUT std_logic;
		clk_100Hz : OUT std_logic;
		clk_10Hz : OUT std_logic;
		clk_1Hz : OUT std_logic
		);
	END COMPONENT;

	COMPONENT switchSegment
	PORT(
		clk : IN std_logic;          
		Selseg : OUT std_logic_vector(3 downto 0);
		SelBCD : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT BCD
	PORT(
		BCD_num : IN std_logic_vector(3 downto 0);          
		Seg : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
   COMPONENT MUX16to4
	PORT(
		x : IN std_logic_vector(15 downto 0);
		Sel : IN std_logic_vector(1 downto 0);          
		Sout : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT mux4to1
	PORT(
		x : IN std_logic_vector(3 downto 0);
		s : IN std_logic_vector(1 downto 0);          
		y : OUT std_logic
		);
	END COMPONENT;


    signal clk_switch: std_logic:='0';
	 signal SelBCD : STD_LOGIC_VECTOR (1 downto 0):="00";
	 signal BCDNum : STD_LOGIC_VECTOR (3 downto 0):="0000";


begin	
	Inst_clkGenerator: clkGenerator PORT MAP(
		clk_in => clk_100MHz,
		clk_1KHz =>  clk_switch
		--clk_100Hz => ,
		--clk_10Hz => ,
		--clk_1Hz => 
	);

	Inst_switchSegment: switchSegment PORT MAP(
		clk => clk_switch,
		Selseg => an,
		SelBCD => SelBCD 
	);
	Inst_BCD: BCD PORT MAP(
		BCD_num => BCDNum,
		Seg => Seg
	);
	Inst_MUX16to4: MUX16to4 PORT MAP(
		x => digitValue,
		Sel => SelBCD,
		Sout => BCDNum
	);
	Inst_mux4to1: mux4to1 PORT MAP(
		x => digitDp,
		s => SelBCD,
		y => dp_led
	);
end Behavioral;

