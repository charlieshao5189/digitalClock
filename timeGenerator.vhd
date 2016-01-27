----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:14:48 03/10/2015 
-- Design Name: 
-- Module Name:    timeGenerator - Behavioral 
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

entity timeGenerator is
    Port ( clk_1Hz: in  STD_LOGIC;-- inpute 1Hz clock
           hourMinute : out  STD_LOGIC_VECTOR (15 downto 0);--BCD value of hour and Minute
           second_DP : out  STD_LOGIC_VECTOR (3 downto 0); -- control the leds on SSD to twinkle to show the second is counting
			  second: out  STD_LOGIC_VECTOR (5 downto 0) -- binary value of second, connnected with 6 leds, 0-59
			  );
end timeGenerator;

architecture Behavioral of timeGenerator is


	COMPONENT twoDigitBCD
	PORT(
		binNumber : IN std_logic_vector(6 downto 0);          
		tenths_ones : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;


signal sec,min,hour : integer range 0 to 60 :=0;
signal count : integer :=1;
signal minutesBCD: std_logic_vector(7 downto 0):=(others=>'0') ;
signal hoursBCD: std_logic_vector(7 downto 0):=(others=>'0') ;

signal second_DP_temp:STD_LOGIC_VECTOR (3 downto 0):=(others=>'1'); -- control the leds on SSD to twinkle to show the second is counting
--hour_vector,min_vector used to kill warning
signal hour_vector : STD_LOGIC_VECTOR( 6 downto 0):=(others=>'0'); 
signal min_vector : STD_LOGIC_VECTOR( 6 downto 0):=(others=>'0'); 

begin
   
	second_DP_temp(1 downto 0)<="11";
	second_DP_temp(3)<='1';
   second_DP <= second_DP_temp;--only change second_DP_temp(2) every second, others leds always keep off
	
	second <=std_logic_vector(TO_UNSIGNED(sec,6));
   hourMinute <= hoursBCD & minutesBCD;
	
	min_vector<=std_logic_vector(TO_UNSIGNED(min,7));
	Inst_twoDigitBCD_m: twoDigitBCD PORT MAP(
		binNumber => min_vector,
		tenths_ones => minutesBCD 
	);
	hour_vector<=std_logic_vector(TO_UNSIGNED(hour,7));
	Inst_twoDigitBCD_h: twoDigitBCD PORT MAP(
		binNumber => hour_vector,
		tenths_ones => hoursBCD
	);



Process_clk_1Hz: process(clk_1Hz)   --period of clk_1Hz is 1 second.
			begin
					if(clk_1Hz'event and clk_1Hz='1') then
							sec <= sec+ 1;
							Second_DP_temp(2)<= not Second_DP_temp(2) ;					
							if(sec = 59) then
										sec<=0;
										min <= min + 1;
							if(min = 59) then
									hour <= hour + 1;
									min <= 0;
									if(hour = 23) then
											hour <= 0;
									end if;
							end if;
					end if;
			end if;
end process;
end Behavioral;

