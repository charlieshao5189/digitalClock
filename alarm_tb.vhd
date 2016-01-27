--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:36:04 01/26/2016
-- Design Name:   
-- Module Name:   /home/charlie/Documents/VHDL/Nexys3Projects/myLib/digitClock/alarm_tb.vhd
-- Project Name:  digitClock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alarm
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alarm_tb IS
END alarm_tb;
 
ARCHITECTURE behavior OF alarm_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alarm
    PORT(
         clk_100MHz : IN  std_logic;
         alarmSwitch : IN  std_logic;
         buttons : IN  std_logic_vector(4 downto 0);
         HourMinute_time : IN  std_logic_vector(15 downto 0);
         HourMinute_alarm : OUT  std_logic_vector(15 downto 0);
         alarmLed : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_100MHz : std_logic := '0';
   signal alarmSwitch : std_logic := '0';
   signal buttons : std_logic_vector(4 downto 0) := (others => '0');
   signal HourMinute_time : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal HourMinute_alarm : std_logic_vector(15 downto 0);
   signal alarmLed : std_logic;

   -- Clock period definitions
   constant clk_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alarm PORT MAP (
          clk_100MHz => clk_100MHz,
          alarmSwitch => alarmSwitch,
          buttons => buttons,
          HourMinute_time => HourMinute_time,
          HourMinute_alarm => HourMinute_alarm,
          alarmLed => alarmLed
        );

   -- Clock process definitions
   clk_100MHz_process :process
   begin
		clk_100MHz <= '0';
		wait for clk_100MHz_period/2;
		clk_100MHz <= '1';
		wait for clk_100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
         -- hold reset state for 100 ns.
		wait for 100ms;
		
		--test right_button and left button    	
      buttons <= "00100";
		wait for 100ms;	--position=1
		buttons <= "00100";
		wait for 100ms;   --position=0
		
		buttons <= "00010";
		wait for 100ms;	--position=1
		buttons <= "00010";
		wait for 100ms;   --position=0
		
		--test up_button and down_button,increase and decrease number   
		buttons <= "10000";
		wait for 100ms;	--hour+1
		buttons <= "10000";
		wait for 100ms;   --hour+1
		
		buttons <= "01000";
		wait for 100ms;	--hour-1
		buttons <= "01000";
		wait for 100ms;   --hour-1
		
		--test alarm active
		HourMinute_time <=x"0025";
		HourMinute_alarm<=x"0025";
		alarmSwitch<='0';
		wait for 200ms;--alarmLed will twinkl
		alarmSwitch<='1';
		wait for 200ms;--alarmLed will stope twinkl
   end process;

END;
