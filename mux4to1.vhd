----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:58:25 10/26/2015 
-- Design Name: 
-- Module Name:    mux4to1 - Behavioral 
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

entity mux4to1 is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           s : in  STD_LOGIC_VECTOR (1 downto 0);
           y : out  STD_LOGIC);
end mux4to1;

architecture Behavioral of mux4to1 is
	signal sig : std_logic_vector(1 downto 0);
	
	component mux2to1 is
    Port ( 	x  : in  STD_LOGIC_VECTOR(1 downto 0);
				s  : in  STD_LOGIC;
				y  : out  STD_LOGIC
			  );
	end component;

begin


	Inst_mux2to1_a: mux2to1 PORT MAP(
		x =>x(1 downto 0) ,
		s =>s(0) ,
		y =>sig(0)
	);
	Inst_mux2to1_b: mux2to1 PORT MAP(
		x =>x(3 downto 2),
		s =>s(0) ,
		y =>sig(1) 
	);	
	Inst_mux2to1_c: mux2to1 PORT MAP(
		x =>sig ,
		s =>s(1),
		y =>y
	);
	
end Behavioral;