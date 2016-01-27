----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:36 01/24/2016 
-- Design Name: 
-- Module Name:    alarm - Behavioral 
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


entity alarm is
 Port (  
	        clk_100MHz: in STD_LOGIC;
			  alarmSwitch: in STD_LOGIC; -- turn on or turn off the alarm function
	        buttons   : in   STD_LOGIC_VECTOR( 4 downto 0);--bt_up:increase & bt_down: decrease & bt_left: move to left digit & bt_right:move to right digit &bt_center:not used
			  HourMinute_time: in  STD_LOGIC_VECTOR( 15 downto 0);-- BCD value of hour and minute from time, when it's the same with HourMinute_alarm, alarm is activated,led will twinkle quickly
			  
			  HourMinute_alarm: out  STD_LOGIC_VECTOR( 15 downto 0);-- combination of BCD value of hour and minute
			  alarmLed: out STD_LOGIC -- twinkle quickly when the time match with alarm time, this will go on one minute. use alram_on_off switch to control it work or not
			 );
end alarm;

architecture Behavioral of alarm is

	COMPONENT debouncer-- used to debounce when push the button
	PORT(
		pb : IN std_logic;    --button input
		clock_100Hz : IN std_logic;          
		pb_debounced : OUT std_logic--output debounced signal, 1:button pushed,0: button is not pushed or not stable
		);
	END COMPONENT;

	COMPONENT twoDigitBCD -- convert two digit number to two digit bcd value
	PORT(
		binNumber : IN std_logic_vector(6 downto 0);  --two digit number 00-99
		tenths_ones : OUT std_logic_vector(7 downto 0)--output bcd values of two digit
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



   signal min,hour : integer range -1 to 60 :=0;--integer min,hour used for caculation
	signal position: integer range -1 to 2:=0;--0:setting hour,hour will twinkl,1: setting minute, minute will twinkl
	
	signal buttons_temp: STD_LOGIC_VECTOR( 4 downto 0):=(others=>'0'); --store debounced buttons value
	signal buttons_temp_last: STD_LOGIC_VECTOR( 4 downto 0):=(others=>'0');--store last time's buttons_temp value
	
	--hours and minute  BCD values
	signal minutesBCD: std_logic_vector(7 downto 0):=(others=>'0') ;
   signal hoursBCD: std_logic_vector(7 downto 0):=(others=>'0') ;
	
   -- receive vector vaule of hour,minute convert from integer 
	signal hour_vector : STD_LOGIC_VECTOR( 6 downto 0):=(others=>'0'); 
	signal min_vector : STD_LOGIC_VECTOR( 6 downto 0):=(others=>'0'); 
	
	
   signal clk_s: std_logic:='0';-- used in digit twinkle process
	signal clk_10ms: std_logic:='0';
	signal clk_100ms: std_logic:='0';

	
begin	
	
	Inst_clkGenerator: clkGenerator PORT MAP(
		clk_in => clk_100MHz,
		--clk_1KHz => ,
		clk_100Hz => clk_10ms ,
		clk_10Hz =>clk_100ms ,
		clk_1Hz =>clk_s 
	);
   --when hour or minute is chosed to set new value, it will twinkl,position decide which one be chosed
   digit_twinkl_process:process(clk_s,position,hoursBCD,minutesBCD)
	begin
	if clk_s = '0' then --in 0.5 second, the chosed two digit(hour or minute) will turn off all seven leds, "F"is set as turn off all leds.
		if position = 0 then   -- choose to change hour of alarm 
		    hourMinute_alarm <= x"FF"& minutesBCD;--in 0.5 second,hour position displays nothing like "  ".
		else if position = 1 then  -- choose to change minute of alarm
		   hourMinute_alarm <= hoursBCD & x"FF"; --in 0.5 second,minute position displays nothing like "  ".
		else hourMinute_alarm <= hoursBCD & minutesBCD;
		end if;
		end if;
	else hourMinute_alarm <= hoursBCD & minutesBCD;
	end if;
	end process;
	
	--convert two digit to BCD 
	min_vector<=std_logic_vector(TO_UNSIGNED(min,7));--for kill warning 
	Inst_twoDigitBCD_m: twoDigitBCD PORT MAP(
		binNumber =>min_vector,         
		tenths_ones => minutesBCD 
	);
   hour_vector<=std_logic_vector(TO_UNSIGNED(hour,7));--for kill warning 
	Inst_twoDigitBCD_h: twoDigitBCD PORT MAP(
		binNumber =>hour_vector,
		tenths_ones => hoursBCD
	);
	
	--debounce all the five buttons
	Inst_debouncer_0: debouncer PORT MAP(
		pb =>buttons(0) ,
		clock_100Hz => clk_10ms ,
		pb_debounced =>buttons_temp(0)
	);
	Inst_debouncer_1: debouncer PORT MAP(
		pb =>buttons(1) ,
		clock_100Hz => clk_10ms ,
		pb_debounced =>buttons_temp(1)
	);
	Inst_debouncer_2: debouncer PORT MAP(
		pb =>buttons(2) ,
		clock_100Hz => clk_10ms,
		pb_debounced =>buttons_temp(2)
	);
	Inst_debouncer_3: debouncer PORT MAP(
		pb =>buttons(3) ,
		clock_100Hz => clk_10ms,
		pb_debounced =>buttons_temp(3)
	);
	Inst_debouncer_4: debouncer PORT MAP(
		pb =>buttons(4) ,
		clock_100Hz => clk_10ms,
		pb_debounced =>buttons_temp(4)
	);

  --button scan and deal process
 configure_alarm_process:process(clk_10ms,buttons_temp,position,hour,min)
  begin
	if clk_10ms'event and clk_10ms='1' then
   if buttons_temp /= buttons_temp_last then
	   buttons_temp_last <= buttons_temp ;
		case buttons_temp is
		when "00100" =>  
			position <= position-1;
		when "00010" =>  
			position <= position+1;
		when "10000" =>  
			case position is
			when 0 =>
				hour<=hour+1;
			when 1 =>
					min<=min+1;
			when others=>
			end case;
		when "01000" =>  
			case position is
			when 0 =>
				hour<=hour-1;
			when 1 =>
					min<=min-1;
			when others=>	
			end case;
		when others=>
		end case;
	end if;
	-- make sure the value of position,hour,minute in their own scope
	if position > 1 then
		position <= 0;
	else if position < 0 then
		position <= 1;
	end if;
	end if;
	if hour < 0 then
		hour <= 23;
	else if hour >23 then
		hour <= 0;
	end if;
	end if;
	
	if min < 0 then
		min <= 59;
	else if min >59 then
		min <= 0;
	end if;
	end if;

	end if;
   end process;
	
	--compare HourMinute_time and HourMinute_alarm, when they are equal, activate alarm
   comperation_process:process(HourMinute_time,hoursBCD,minutesBCD,alarmSwitch,clk_100ms)
   begin
	if HourMinute_time = hoursBCD&minutesBCD and alarmSwitch='0' then
	   if clk_100ms='0' then
			alarmLed <= '0';
		else
		   alarmLed <= '1';
	   end if;
	else alarmLed <= '0';
	end if;
	end process;
	
end Behavioral;