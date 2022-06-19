library ieee;
use ieee.std_logic_1164.all;


entity demux is
port (

	clk : in std_logic;
	inputData : in std_logic_vector(16 downto 0);
	
	output_L : out std_logic_vector(15 downto 0);
	output_R : out std_logic_vector(15 downto 0)
);
end entity;
architecture demuxBehave of demux is


begin

process(clk)
begin

if (rising_edge(clk)) then
	
	if (inputData(16) = '0') then
		output_L <= inputData(15 downto 0);
	else 
		output_R <= inputData(15 downto 0);
	end if;
	
end if;
end process;

end demuxBehave;