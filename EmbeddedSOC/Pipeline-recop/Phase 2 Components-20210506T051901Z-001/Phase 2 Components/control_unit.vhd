-- Cecil Symes

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;


entity control_unit is
	port (
		clk					: in bit_1;
		-- Input
		am						: in bit_2; -- Addressing Mode
		opcode				: in bit_6; -- Opcode
		-- Mux select signals
		pc_mux_sel			: out bit_2 := "00";
		reg_mux_sel			: out bit_2 := "00";
		alu_mux_a_sel		: out bit_1 := '0';
		alu_mux_b_sel		: out bit_1 := '0';
		data_wr_mux_sel	: out bit_1 := '0';
		wr_add_mux_sel		: out bit_1 := '0';
		rd_add_mux_sel		: out bit_1 := '0'
	);
end control_unit;

architecture behaviour of control_unit is
	signal pc_mux_sel_int	: bit_2 := "00";
begin
	-- Use addressing mode to set:
	-- alu_mux_a_sel, alu_mux_b_sel, wr_add_mux_sel, rd_add_mux_sel
	am_decode : process (clk)
	begin
		case am is
			when am_inherent =>
				alu_mux_a_sel 	<= '0'; -- Don't care
				alu_mux_b_sel	<= '0'; -- Don't care
				wr_add_mux_sel	<= '0'; -- Don't care
				rd_add_mux_sel	<= '0'; -- Don't care
			when am_immediate =>
				alu_mux_a_sel 	<= '0'; -- x_out
				alu_mux_b_sel	<= '1'; -- operand
				wr_add_mux_sel	<= '0'; -- z_out
				rd_add_mux_sel	<= '1'; -- operand
			when am_direct =>
				alu_mux_a_sel 	<= '0'; -- Don't care
				alu_mux_b_sel	<= '0'; -- Don't care
				wr_add_mux_sel	<= '1'; -- operand
				rd_add_mux_sel	<= '1'; -- operand
			when am_register =>
				alu_mux_a_sel 	<= '0'; -- Don't care
				alu_mux_b_sel	<= '0'; -- Don't care
				wr_add_mux_sel	<= '0'; -- Don't care
				rd_add_mux_sel	<= '0'; -- Don't care
			
		end case;
	end process am_decode;
	
	-- Use opcode to decode:
	-- pc_mux_sel, reg_mux_sel, data_wr_mux_sel
	opcode_decode : process (clk)
	begin
		pc_mux_sel_int <= "00"; -- default to increment
		
		-- pc_mux_sel
		if opcode = jmp then
			if am = am_immediate then
				pc_mux_sel_int <= "01"; -- operand
			elsif am = am_register then
				pc_mux_sel_int <= "10"; -- x_out
			end if;
		
		-- PRESENT opcode
		-- elsif opcode = "011100" then					TODO: implement PRESENT logic
		
		-- SZ opcode
		-- elsif opcode = "010100" then					TODO: implement SZ logic
		end if;
		
		
		
		-- reg_mux_sel
		if (opcode = andr) or (opcode = orr) or (opcode = addr) or (opcode = subvr) then
			reg_mux_sel <= "00"; -- ALU_out							TODO: Ensure the control signal matches
		
		elsif opcode = ldr then
			if am = am_immediate then
				reg_mux_sel <= "00"; -- operand						TODO: Ensure the control signal matches
			else
				reg_mux_sel <= "11"; -- mem_read_out				TODO: Ensure the control signal matches
			end if;
		
		elsif opcode = ler then
			reg_mux_sel <= "10"; -- environment						TODO: Ensure the control signal matches
		
		elsif opcode = lsip then
			reg_mux_sel <= "10"; -- environment						TODO: Ensure the control signal matches
		
		elsif opcode = max then
			reg_mux_sel <= "10"; -- ALU_out/MAX?					TODO: Ensure the control signal matches
		
		end if;
		
		-- data_wr_mux_sel
		if opcode = str then
			if am = am_immediate then
				data_wr_mux_sel <= '1'; -- Operand
			else
				data_wr_mux_sel <= '0'; -- x_out
			end if;
			
		-- elsif opcode = strpc											TODO: implement STRPC logic
		end if;
	end process opcode_decode;

end behaviour;
