library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.recop_types.all;
use work.opcodes.all;

-- selects the data source going to the data memory

entity dm_address_mux is
    port (
		-- mux selection signal
		dm_data_sel: in bit_1;
		
		-- data sources & output
		Rz: in bit_16 := X"0000";
		ir_operand: in bit_16 := X"0000";
		
		dm_add : out bit_16 := X"0000"
		);
		
end dm_address_mux;

architecture beh of dm_address_mux is
  begin
	--MUX selecting data
	process (dm_data_sel, Rz, ir_operand)
	begin
		case dm_data_sel is
			when '0' =>
				dm_add <= Rz;
			when '1' =>
				dm_add <= ir_operand;
		end case;
	end process;

end beh;
