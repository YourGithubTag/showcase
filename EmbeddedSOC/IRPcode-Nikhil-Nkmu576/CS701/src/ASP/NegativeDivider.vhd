library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NEGDivider is port (
    clk : in std_logic;
	 enable: in std_logic;
	 
	 input : in std_logic_vector(15 downto 0);
	 input_shift : in std_logic_vector(15 downto 0);
	 
	 output : out std_logic_vector(15 downto 0)
        );
end NEGDivider;


architecture arch of NEGDivider is

SIGNAL Div_num : signed(31 downto 0);
SIGNAL negative: signed(15 downto 0) := to_signed(-1,16);

begin

divide: process(clk)
	begin
		if rising_edge(clk) then 
			if enable = '1' then 
				Div_num <= negative * (shift_right(signed(input), to_integer(signed(input_shift))));
			else
				Div_num <= x"00000000";
			end if;
		end if;
end process divide;

output <= std_logic_vector(Div_num(15 downto 0));

end architecture arch;
