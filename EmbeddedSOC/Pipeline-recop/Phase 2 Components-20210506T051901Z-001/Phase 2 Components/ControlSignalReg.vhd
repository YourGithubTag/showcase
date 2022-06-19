

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity ControlSignalReg is 
port (
		clk					: in bit_1;
		reset					: in bit_1;
		-- Mux select signals
		pc_mux_sel			: in bit_2;
		reg_mux_sel			: in bit_2; 
		alu_mux_a_sel		: in bit_1; 
		alu_mux_b_sel		: in bit_1; 
		data_wr_mux_sel	: in bit_1; 
		wr_add_mux_sel		: in bit_1; 
		rd_add_mux_sel		: in bit_1;
		
		pc_mux_sel_out			: out bit_2;
		reg_mux_sel_out		: out bit_2; 
		alu_mux_a_sel_out		: out bit_1; 
		alu_mux_b_sel_out		: out bit_1; 
		data_wr_mux_sel_out	: out bit_1; 
		wr_add_mux_sel_out	: out bit_1; 
		rd_add_mux_sel_out	: out bit_1
		
	);
	
end entity;

architecture regBehave of ControlSignalReg is

begin 

PROCESS (reset, clk)

begin

	if (reset = '1') then
	
			pc_mux_sel_out<= "00";
			reg_mux_sel_out<= "00"; 
			alu_mux_a_sel_out<= '0'; 
			alu_mux_b_sel_out<= '0'; 
			data_wr_mux_sel_out<= '0'; 
			wr_add_mux_sel_out<= '0';  
			rd_add_mux_sel_out<= '0'; 
			
	elsif rising_edge(clk) then 
	
			pc_mux_sel_out<= pc_mux_sel;
			reg_mux_sel_out<= reg_mux_sel; 
			alu_mux_a_sel_out<= alu_mux_a_sel; 
			alu_mux_b_sel_out<= alu_mux_b_sel; 
			data_wr_mux_sel_out<= data_wr_mux_sel; 
			wr_add_mux_sel_out<= wr_add_mux_sel;  
			rd_add_mux_sel_out<= rd_add_mux_sel; 

	end if;
	
end PROCESS;
end architecture;
		