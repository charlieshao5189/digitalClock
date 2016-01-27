----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:57:40 01/23/2016 
-- Design Name: 
-- Module Name:    digitClock - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digitClock is

    Port ( clk_100MHz : in   STD_LOGIC;	 
	        buttons   : in   STD_LOGIC_VECTOR( 4 downto 0);--bt_up&bt_down&bt_left&bt_right&bt_center
	        mode      : in   STD_LOGIC_VECTOR( 2 downto 0);--two switchs to control mode
			  
			 -- switch_hf : in   STD_LOGIC; --12/24 hour formate switch
			  alarmSwitch: in STD_LOGIC; -- switch for alarm
			  
			  led_hf    : out  STD_LOGIC; -- off: 24hour  on:12hour
			  alarmLed: out STD_LOGIC;    -- twinkle when alarm is actived
			  
	        an 			: out  STD_LOGIC_VECTOR (3 downto 0);
           Seg 		: out  STD_LOGIC_VECTOR (6 downto 0);
			  seg_dp 	: out  STD_LOGIC;
			  second_leds: out STD_LOGIC_VECTOR (5 downto 0)
          );		 
end digitClock;

architecture Behavioral of digitClock is

	COMPONENT fourDigitDisplay
	PORT(
		clk_100MHz : IN std_logic;
		digitValue : IN std_logic_vector(15 downto 0);--BCD value 
		digitDp : IN std_logic_vector(3 downto 0);          
		an : OUT std_logic_vector(3 downto 0);
		seg : OUT std_logic_vector(6 downto 0);
		dp_led : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT clkGenerator
	PORT(
		clk_in : IN std_logic;          
		clk_1KHz : OUT std_logic;
		clk_100Hz : OUT std_logic;
		clk_10Hz : OUT std_logic;
		clk_1Hz : OUT std_logic
		);
	END COMPONENT;

	
	COMPONENT timeGenerator
	PORT(
		clk_1Hz : IN std_logic;          
		hourMinute : OUT std_logic_vector(15 downto 0);
		second_DP : OUT std_logic_vector(3 downto 0);
		second : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;

	COMPONENT alarm
	PORT(
		clk_100MHz : IN std_logic;
		alarmSwitch : IN std_logic;
		buttons : IN std_logic_vector(4 downto 0);
		HourMinute_time : IN std_logic_vector(15 downto 0);          
		HourMinute_alarm : OUT std_logic_vector(15 downto 0);
		alarmLed : OUT std_logic
		);
	END COMPONENT;

   signal digitValue : std_logic_vector(15 downto 0):=(others=>'0');--the two digital BCD values will bee sent to ssd to display
	signal digitDp : std_logic_vector(3 downto 0):=(others=>'0');-- used to control the leds(Decimal point) on ssd
	
	signal hourMinute_time : std_logic_vector(15 downto 0):=(others=>'0');--Hour,Minute BCD value on timeMode 
	signal second_time: STD_LOGIC_VECTOR (5 downto 0):=(others=>'0');--second on timeMode
	signal second_DP :  std_logic_vector(3 downto 0):=(others=>'0'); --the third point on ssd, off/on to show second counting
	
	signal hourMinute_alarm : std_logic_vector(15 downto 0):=(others=>'0');--hour and minute have been formated to BCD fit dispaly

	signal clk_1Hz :  std_logic:='0';--connect clk_1Hz and clk_1s
	signal clk_100Hz :  std_logic:='0';--connect clk_100Hz


	
begin

   led_hf <='1';-- show hour formate:on:24H off:12h, when it is 12h formate, two leds close to ssd will show morning and afternoon. 

   -- there are five mode in this design,using SW2,SW1,SW0 chose mode 
	displaySignalsSwitch:process(mode,hourMinute_time,second_DP,second_time,hourMinute_alarm)
	begin
	--   if clk_100Hz'event and clk_100Hz='1' then
		case mode is
			when "000" =>   --time mode
             digitValue<= hourMinute_time ;-- give hour and minute value to SSD to display
				 digitDp <= second_DP;    -- this control led on to show second counting 
				 second_leds<=second_time; -- use six leds show second value
			when "001" =>    --date mode
			    digitValue<= x"FFA1";
				 digitDp <= "0000";    -- turn off all leds 
				 second_leds<="111111";---- turn off all leds
			when "010" =>    --alarm mode
			    digitValue<= hourMinute_alarm ;-- give hour and minute of alarm to SSD to display
				 digitDp <= "1111";    -- turn off all leds on alarmMode 
				 second_leds<="000000";---- turn off all leds on alarmMode 
			when "011" =>  --stopwatch mode
			    digitValue<= x"FFA2";
				 digitDp <= "0000";    -- turn off all leds 
				 second_leds<="111111";---- turn off all leds
			when "100" =>  --timer mode		
			    digitValue<= x"FFA3";
				 digitDp <= "0000";    -- turn off all leds 
				 second_leds<="111111";---- turn off all leds
			when others =>
			    digitValue<= x"0000";
			    digitDp <= "0000";    -- turn off all leds 
				 second_leds<="111111";---- turn off all leds
		end case;
	--	end if;
	end process;	
	
	
	
   Inst_fourDigitDisplay: fourDigitDisplay PORT MAP(
		clk_100MHz => clk_100MHz ,
		digitValue => digitValue,
		digitDp => digitDp ,
		an => an,
		seg => seg,
		dp_led => seg_dp 
	);
	
	Inst_clkGenerator: clkGenerator PORT MAP(
		clk_in =>clk_100MHz ,
		--clk_1KHz => ,
		clk_100Hz =>clk_100Hz ,
		--clk_10Hz => ,
		clk_1Hz => clk_1Hz
	);

	Inst_timeGenerator: timeGenerator PORT MAP(
		clk_1Hz => clk_1Hz,
		hourMinute => hourMinute_time ,
		second_DP => second_DP,
		second => second_time
	);

	Inst_alarm: alarm PORT MAP(
		clk_100MHz => clk_100MHz ,
		alarmSwitch => alarmSwitch,
		buttons => buttons,
		HourMinute_time => HourMinute_time,
		HourMinute_alarm => hourMinute_alarm,
		alarmLed => alarmLed
	);
	 
end Behavioral;

