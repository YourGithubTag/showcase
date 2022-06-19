library ieee;
use ieee.std_logic_1164.all;


entity LRDiff is
port (

	clk : in std_logic;
	
	out_selL : in std_logic;
	out_selR : in std_logic;
	input_1 : in std_logic_vector(15 downto 0);
	input_2 : in std_logic_vector(15 downto 0);
	
	Output : out std_logic_vector(16 downto 0)
);

end entity;
architecture Behave of LRDiff is

SIGNAL input_1_t :  std_logic_vector(15 downto 0);
SIGNAL input_2_t :  std_logic_vector(15 downto 0);
	
begin

input_1_t <= input_1;
input_2_t <= input_2;

process(clk)
begin

if (rising_edge(clk)) then

	if (out_selL = '1') then
		Output <= '0' & input_1_t;
	elsif (out_selR = '1') then
		Output <= '1' & input_2_t;
	end if;
	
end if;
end process;

end Behave;