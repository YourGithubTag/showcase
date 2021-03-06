

library ieee;
use ieee.std_logic_1164.all;
use work.recop_types.all;

entity ExecuteReg is 
PORT (
	clk : in bit_1;
	reset : in bit_1;
	
	Rx_SEL :	in bit_4;
	Rz_SEL : in  bit_4;
	operand : in bit_16;
	
	Rx_SEL_OUT : out bit_4;
	Rz_SEL_OUT : out bit_4;
	operand_OUT: out bit_16
) ; 
end ExecuteReg;

architecture regBehave of ExecuteReg is 

begin 

PROCESS (reset, clk)
begin 

	if (reset = '1') then
	
		Rx_SEL_OUT <= "0000";
		Rz_SEL_OUT <= "0000";
		operand_OUT <= x"0000";
		
	elsif rising_edge(clk) then 
	
		Rx_SEL_OUT <= Rx_SEL;
		Rz_SEL_OUT <= Rz_SEL;
		operand_OUT  <= operand;

	end if;
	
end PROCESS;

end architecture;