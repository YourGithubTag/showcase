library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity zblock is
port(

  i_clk             : in  std_logic;
  i_sync_reset      : in  std_logic;
  i_data            : in  std_logic_vector(15 downto 0);
  o_data            : out std_logic_vector(15 downto 0));
  
end zblock;
architecture rtl of zblock is

SIGNAL LATCH : std_logic_vector(15 downto 0):= x"0000" ;

begin

process(i_clk)
begin

if (rising_edge(i_clk)) then
	LATCH <= i_data;
end if;

end process;

o_data <= LATCH;
end rtl;