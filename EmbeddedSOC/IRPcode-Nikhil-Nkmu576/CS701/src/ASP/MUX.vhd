library ieee;
use ieee.std_logic_1164.all;


entity mux4to1 is
port (

	clk : in std_logic;
	
	output_sel : in std_logic_vector(1 downto 0);
	
	input_1 : in std_logic_vector(16 downto 0);
	input_2 : in std_logic_vector(16 downto 0);
	input_3 : in std_logic_vector(16 downto 0);
	input_4 : in std_logic_vector(16 downto 0);
	
	Output : out std_logic_vector(16 downto 0)
);

end entity;
architecture muxBehave of mux4to1 is

SIGNAL input_1_t :  std_logic_vector(16 downto 0);
SIGNAL input_2_t :  std_logic_vector(16 downto 0);
SIGNAL input_3_t :  std_logic_vector(16 downto 0);
SIGNAL input_4_t :  std_logic_vector(16 downto 0);
	
begin

input_1_t <= input_1;
input_2_t <= input_2;
input_3_t <= input_3;
input_4_t <= input_4;

process(clk)
begin

if (rising_edge(clk)) then

	case output_sel is
		when "00" => 
		Output <= input_1_t;
		when "01" => 
		Output <= input_2_t;
		when "10" => 
		Output <=  input_3_t;
		when "11" => 
		Output <= input_4_t;
		when others =>
		Output <= "00000000000000000";
	end case;
	
end if;
end process;

end muxBehave;