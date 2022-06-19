library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gainSetter is 
port (
		clk : in std_logic;
		gain_in 	  : in std_logic_vector(15 downto 0);

		GAIN_1 : out std_logic_vector(15 downto 0);
		GAIN_2 : out std_logic_vector(15 downto 0);
		GAIN_3 : out std_logic_vector(15 downto 0);
		GAIN_4 : out std_logic_vector(15 downto 0);
		GAIN_5 : out std_logic_vector(15 downto 0);
		GAIN_6 : out std_logic_vector(15 downto 0)
);

end gainSetter;

Architecture gain_behaviour of gainSetter is

signal input : signed(15 downto 0);

signal GAIN_1_t : signed(23 downto 0);
signal GAIN_2_t : signed(23 downto 0);
signal GAIN_3_t : signed(23 downto 0);
signal GAIN_4_t : signed(23 downto 0);
signal GAIN_5_t : signed(23 downto 0);
signal GAIN_6_t : signed(23 downto 0);


begin

input <= signed(gain_in);

process(clk)
begin

	if (rising_edge(clk)) then 
		GAIN_1_t <= input * x"01";
		GAIN_2_t <= input * x"02";
		GAIN_3_t <= input * x"02";
		GAIN_4_t <= input * x"03";
		GAIN_5_t <= input * x"03";
		GAIN_6_t <= input * x"04";
	end if;
	
end process;

GAIN_1 <= std_logic_vector(GAIN_1_t(15 downto 0));
GAIN_2 <= std_logic_vector(GAIN_2_t(15 downto 0));
GAIN_3 <= std_logic_vector(GAIN_3_t(15 downto 0));
GAIN_4 <= std_logic_vector(GAIN_4_t(15 downto 0));
GAIN_5 <= std_logic_vector(GAIN_5_t(15 downto 0));
GAIN_6 <= std_logic_vector(GAIN_6_t(15 downto 0));

end gain_behaviour;

