library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Divider is port (
    clk : in std_logic;
	 enable: in std_logic;
	 
	 input : in std_logic_vector(15 downto 0);
	 input_shift : in std_logic_vector(15 downto 0);
	 
	 output : out std_logic_vector(15 downto 0)
        );
end Divider;


architecture arch of Divider is

SIGNAL Div_num : signed(15 downto 0);

begin

divide: process(clk)
	begin
		if rising_edge(clk) then 
			if enable = '1' then 
				Div_num <= shift_right(signed(input), to_integer(signed(input_shift)));
			else
				Div_num <= "0000000000000000";
			end if;
		end if;
end process divide;

output <= std_logic_vector(Div_num);

end architecture arch;

