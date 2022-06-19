-- Cecil Symes

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;


entity program_counter is
	port (
		clk				: in bit_1;
		reset				: in bit_1;
		-- Potential inputs
		x_out				: in bit_16;
		operand			: in bit_16;
		-- Muxes
		pc_mux			: in bit_2;
		-- Output
		program_count	: out bit_16
	);
end program_counter;

architecture behaviour of program_counter is
	signal count		: unsigned(15 downto 0) := X"0000";
begin
	-- Increment PC
	count_select : process (clk, reset)
	begin
	
	if reset = '1' then
		count <= x"0000";
	else
		case pc_mux is
			when "00" =>							-- NEED TO UPDATE TO MATCH THE CONTROL SIGNALs
				count <= count + 1;
			when "01" =>
				count <= unsigned(operand);
			when "10" =>
				count <= unsigned(x_out);
			when others =>
				count <= X"0000";
		end case;
	end if;
	end process count_select;


program_count <= std_logic_vector(count);
	
end behaviour;
