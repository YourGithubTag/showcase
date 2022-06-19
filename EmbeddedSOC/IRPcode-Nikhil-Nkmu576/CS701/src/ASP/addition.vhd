library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addition is port (
    clk : in std_logic;
	 enable: in std_logic;
	 
	 inputA : in std_logic_vector(15 downto 0);
	 inputB : in std_logic_vector(15 downto 0);
	 
	 output : out std_logic_vector(15 downto 0)
        );
end addition;


architecture arch of addition is

SIGNAL addition_Num : signed(15 downto 0);

begin

addition: process(clk)
	begin
		if rising_edge(clk) then 
			if enable = '1' then 
				addition_Num <= signed(inputA) + signed(inputB);
			else
				addition_Num <= "0000000000000000";
			end if;
		end if;
end process addition;

output <= std_logic_vector(addition_Num);

end architecture arch;