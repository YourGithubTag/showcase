

library ieee;
use ieee.std_logic_1164.all;
use work.recop_types.all;

entity InstructionReg is 
PORT (
	clk : in bit_1;
	reset : in bit_1;
	instruction: in bit_32;
	AM	: out bit_2;
	Opcode : out bit_6;
	Rx_SEL :	out bit_4;
	Rz_SEL : out bit_4;
	operand : out bit_16
) ; 
end InstructionReg;

architecture regBehave of InstructionReg is 
	signal AM_t	:  bit_2;
	signal Opcode_t :  bit_6;
	signal Rx_SEL_t :	 bit_4;
	signal Rz_SEL_t :  bit_4;
	signal operand_t : bit_16;
begin 

PROCESS (reset, clk)
begin 

	if (reset = '1') then
		AM <= "00";
		Opcode <= "00000";
		Rx_SEL <= "0000";
		Rz_SEL <= "0000";
		operand <= x"0000";
		
	elsif rising_edge(clk) then 
		AM <= instruction(31 downto 30);
		Opcode  <= instruction(29 downto 24);
		Rx_SEL <= instruction(23 downto 20);
		Rz_SEL <= instruction(19 downto 16);
		operand  <= instruction(15 downto 0);
	end if;
	
end PROCESS;

end architecture;