----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:56:39 01/22/2016 
-- Design Name: 
-- Module Name:    clkGenerator - Behavioral 
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

entity clkGenerator is
    generic ( msCounter : integer := 49999); --when original clock is 100MHz, (msCounter+1)*2*(1/100MHz)=1ms,msCounter=49999, clk_1KHz will equal to 1KHz.
    Port ( clk_in : in  STD_LOGIC;     --original clock input, should be 100MHz if what get below frequencies
           clk_1KHz : out  STD_LOGIC;  --output for 1KHz clock
           clk_100Hz : out  STD_LOGIC; --output for 100Hz clock
           clk_10Hz : out  STD_LOGIC;  --output for 10Hz clock
           clk_1Hz : out  STD_LOGIC);  --output for 1Hz clock
end clkGenerator;

architecture Behavioral of clkGenerator is

	signal mscount : natural:=0;    --register to store the count number in process to creat 1Khz clock
	                                --initialized to 0
	signal ms10count : natural:=0;  --register to store the count number in process to creat 100hz clock
	                                --initialized to 0
	signal ms100count : natural:=0;  --register to store the count number in process to creat 10hz clock
	                                --initialized to 0
	signal scount : natural:=0;     --register to store the count number in process to creat 1hz clock
	                                --initialized to 0
	
	signal clk_1KHz_temp : STD_LOGIC:='0'; -- register as buffer for clk_1KHz,so it can be changed in process
	signal clk_100Hz_temp : STD_LOGIC:='0';-- register as buffer for clk_100Hz,so it can be changed in process
	signal clk_10Hz_temp : STD_LOGIC:='0'; -- register as buffer for clk_10z,so it can be changed in process
	signal clk_1Hz_temp : STD_LOGIC:='0';  -- register as buffer for clk_1Hz,so it can be changed in process
	
begin
	
clk_1KHz <= clk_1KHz_temp;
clk_100Hz <= clk_100Hz_temp;
clk_10Hz <= clk_10Hz_temp;
clk_1Hz <= clk_1Hz_temp;

process(clk_in)
begin
if(clk_in'event and clk_in='1') then --a rising edge of the clock will increment mscount
mscount <=mscount+1;
if(mscount = msCounter) then  
clk_1KHz_temp <= not clk_1KHz_temp; -- reverse clk_1KHz_temp
mscount <=0;
end if;
end if;
end process;

process(clk_1KHz_temp)  --use 1KHz clock to creat 100Hz clock
begin
if(clk_1KHz_temp'event and clk_1KHz_temp='1') then--a rising edge of the clock will increment ms10count
ms10count <= ms10count+1;
if(ms10count = 4) then    -- (maxCount+1)*2*(1/1KHz)=10ms, maxCount=4 
clk_100Hz_temp <= not clk_100Hz_temp; --reverse clk
ms10count <= 0;
end if;
end if;
end process;

process(clk_1KHz_temp)
begin
if(clk_1KHz_temp'event and clk_1KHz_temp='1') then
ms100count <= ms100count+1;
if(ms100count= 49) then -- (maxCount+1)*2*(1/1KHz)=100ms, maxCount=49 
clk_10Hz_temp <= not clk_10Hz_temp;
ms100count <=0;
end if;
end if;
end process;

process(clk_1KHz_temp)
begin
if(clk_1KHz_temp'event and clk_1KHz_temp='1') then
scount <= scount+1;
if(scount = 499) then   -- (maxCount+1)*2*(1/1KHz)=1s, maxCount=49 
clk_1Hz_temp <= not clk_1Hz_temp;
scount <= 0;
end if;
end if;
end process;

end Behavioral;

