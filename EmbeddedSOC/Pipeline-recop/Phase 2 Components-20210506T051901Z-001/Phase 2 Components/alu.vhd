-- Cecil Symes

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

-- TODO: Implement max function
-- TODO: Implement the PRESENT instruction

entity alu is
	port (
		clr_zero			: in bit_1;
		alu_operation	: in bit_3;
		-- Operands
		rz					: in bit_16;
		rx					: in bit_16;
		operand			: in bit_16;
		-- Muxes
		alu_mux_a		: in bit_1;
		alu_mux_b		: in bit_1;
		-- Output
		alu_out			: out bit_16;
		zero_flag		: out bit_1
	);
end alu;

architecture combined of alu is
	signal operand_1	: bit_16;
	signal operand_2	: bit_16;
	signal result		: bit_16;
begin
	--MUX selecting first operand
	op1_select: process (alu_mux_a, rx, rz)
	begin
		case alu_mux_a is
			when '0' =>							-- NEED TO UPDATE TO MATCH THE CONTROL SIGNALs
				operand_1 <= rx;
			when '1' =>
				operand_1 <= rz;
			when others =>
				operand_1 <= X"0000";
		end case;
	end process op1_select;
	
	--MUX selecting second operand
	op2_select: process (alu_mux_b, rx, operand)
	begin
		case alu_mux_b is
			when '0' =>
				operand_2 <= rx;
			when '1' =>
				operand_2 <= operand;
			when others =>
				operand_2 <= X"0000";
		end case;
	end process op2_select;
	
	-- perform ALU operation
	alu: process (alu_operation, operand_1, operand_2)
	begin
		case alu_operation is
			when "000" =>
				result <= operand_2 + operand_1;
			when "001" =>
				result <= operand_2 - operand_1;
			when "010" =>
				result <= operand_2 and operand_1;
			when "011" =>
				result <= operand_2 or operand_1;
			when others =>
				result <= X"0000";
		end case;
	end process alu;
	alu_out <= result;

	-- Overflow flag
	zero_detect : process (result)
	begin
		if result = X"0000" then
			zero_flag <= '1';
		else
			zero_flag <= '0';
		end if;
	end process zero_detect;

end combined;