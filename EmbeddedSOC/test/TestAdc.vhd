library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestAdc is
	generic (
		forward : natural
	);
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture sim of TestAdc is
begin

	send.addr <= std_logic_vector(to_unsigned(forward, tdma_min_addr'length));

	process
		type binary is file of integer;
		file audio : binary;
		variable word : integer;
		variable data : std_logic_vector(31 downto 0);
	begin
		file_open(audio, "..\..\wave\wave.wav", read_mode);

		-- Skip wave header
		for i in 1 to 11 loop
			read(audio, word);
		end loop;

		-- Send data
		while not endfile(audio) loop
			read(audio, word);
			data := std_logic_vector(to_signed(word, 32));
			send.data <= x"8000" & data(15 downto 0);
			wait for 20 ns;
			send.data <= x"8001" & data(31 downto 16);
			wait for 20 ns;
			send.data <= (others => '0');
			wait for 1000 ns;
		end loop;

		file_close(audio);
	end process;

end architecture;
