----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:04 01/23/2016 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.numeric_std.all;


ENTITY debouncer IS
    PORT(pb, clock_100Hz : IN    STD_LOGIC;  --pb<='1',when you push down the button 
         pb_debounced     : OUT    STD_LOGIC);
END debouncer;

ARCHITECTURE a OF debouncer IS
    SIGNAL SHIFT_PB : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

-- Debounce Button: Filters out mechanical switch bounce for around 40Ms.
-- Debounce clock should be approximately 10ms
process 
begin
  wait until (clock_100Hz'EVENT) AND (clock_100Hz = '1');
      SHIFT_PB(2 Downto 0) <= SHIFT_PB(3 Downto 1);
      SHIFT_PB(3) <= NOT PB;
      If SHIFT_PB(3 Downto 0)="0000" THEN
        PB_DEBOUNCED <= '1';
      ELSE 
        PB_DEBOUNCED <= '0';
      End if;
end process;
end a;