library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity DPASP is
	port (
		clock : in  std_logic;
		sw    : in  std_logic_vector(9 downto 0);
		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;


architecture control of DPASP is

COMPONENT ASP IS 
	PORT
	(
		CLK_IN :  IN  STD_LOGIC;
		VALIDL :  IN  STD_LOGIC;
		VALIDR :  IN  STD_LOGIC;
		ENABLEROOM :  IN  STD_LOGIC;
		ENABLEALLPASS :  IN  STD_LOGIC;
		ENABLECOMB :  IN  STD_LOGIC;
		RESETROOM :  IN  STD_LOGIC;
		RESETALLPASS :  IN  STD_LOGIC;
		RESETCOMB :  IN  STD_LOGIC;
		DATA_IN :  IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
		GAINCOMPLEX :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		GAINCOMPLEX_SECOND :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUTSEL :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		size_input :  IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
		output :  OUT  STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
	
END COMPONENT;

SIGNAL	enable_allpass :  STD_LOGIC;
SIGNAL	enable_comb :  STD_LOGIC;
SIGNAL	enable_room :  STD_LOGIC;
SIGNAL	Gain_comp :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_comp_SECOND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	output_sel :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	reset_allpass :  STD_LOGIC;
SIGNAL	reset_comb :  STD_LOGIC;
SIGNAL	reset_room :  STD_LOGIC;

SIGNAL RecievedIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_in:  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL aspOUT : STD_LOGIC_VECTOR(16 DOWNTO 0);

SIGNAL DATAOUTPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL VALIDL : STD_LOGIC;
SIGNAL VALIDR : STD_LOGIC;
SIGNAL size_input : STD_LOGIC_VECTOR(11 DOWNTO 0);

SIGNAL Parameters: STD_LOGIC_VECTOR(15 DOWNTO 0);

begin


datapath: ASP
PORT MAP (
		CLK_IN  => clock,
		VALIDL => VALIDL,
		VALIDR => VALIDR,
		ENABLEROOM => enable_room,
		ENABLEALLPASS => enable_allpass,
		ENABLECOMB => enable_comb,
		RESETROOM  => reset_room,
		RESETALLPASS => reset_allpass,
		RESETCOMB  => reset_comb,
		DATA_IN  => data_in,
		GAINCOMPLEX => Gain_comp,
		GAINCOMPLEX_SECOND => Gain_comp_SECOND,
		OUTPUTSEL => output_sel,
		size_input => size_input,
	   output => aspOUT
);

process(clock)
VARIABLE switchState: std_logic_vector(1 downto 0);
begin

if (rising_edge(clock)) then

	switchState := sw(1 downto 0);
	
	Gain_comp <= x"0002";
	Gain_comp_SECOND <= x"0003";
	size_input <= "111111111100";
	
	case switchState is
	
		when "00" =>
			enable_allpass  <= '0';
			enable_comb  <= '0';
			enable_room <= '1';
			
			reset_allpass <= '1';
			reset_comb <= '1';
			reset_room <= '0';
			output_sel <= "00";
			
		when "01" =>
			enable_allpass  <= '1';
			enable_comb  <= '0';
			enable_room <= '0';
			
			reset_allpass <= '0';
			reset_comb <= '1';
			reset_room <= '1';
			output_sel <= "01";
			
		when "10" =>
			enable_allpass  <= '0';
			enable_comb  <= '1';
			enable_room <= '0';
			
			reset_allpass <= '1';
			reset_comb <= '0';
			reset_room <= '1';
			output_sel <= "10";
			
		when "11" =>
			enable_allpass  <= '0';
			enable_comb  <= '0';
			enable_room <= '0';
			
			reset_allpass <= '1';
			reset_comb <= '1';
			reset_room <= '1';
			
			output_sel <= "11";
			
		when others =>
			enable_allpass  <= '0';
			enable_comb  <= '0';
			enable_room <= '0';
			
			reset_allpass <= '1';
			reset_comb <= '1';
			reset_room <= '1';
	
			output_sel <= "11";
			
		end case;
			
end if;
end process;


process(clock)
begin
if (rising_edge(clock)) then
		if recv.data(31 downto 28) = "1000" then
			RecievedIn <= recv.data;
			data_in <= RecievedIn(16 downto 0);
			send.data <= RecievedIn(31 downto 17) & aspOUT;
			send.addr <= x"01";
			
			if (recv.data(16) = '0') then
				VALIDR <= '0';
				VALIDL <= '1';
			elsif (recv.data(16) = '1') then
				VALIDR <= '1';
				VALIDL <= '0';
			else 
				VALIDR <= '0';
				VALIDL <= '0';
			end if;
			
		else 
			VALIDL <= '0';
			VALIDR <= '0';
		end if;
		
end if;
end process;


--fsm : process(clk)
--		-- FSM variable declarations
--		variable dpasp_next_state : dpasp_state_type := Reset;
--	begin
--		if rising_edge(clk) then
--			
--			-- Read configuration packet, dpasp_next_state is only used in Reset, Idle, and Direct
--			if recv.data(31 downto 28) = "1001" then
--
--				case recv.data(19 downto 16) is
--				when "0000" =>
--					dpasp_next_state := Reset;
--				
--				when "0001" =>
--					dpasp_next_state := Direct;
--					next_dest <= recv.data(23 downto 20);
--				when "0010" =>
--					dpasp_next_state := StoreMem;
--					
--				when "0011" =>
--					dpasp_next_state := MovingAvg;
--
--				when "0100" =>
--					dpasp_next_state := FIR;
--
--				when "0101" =>
--					dpasp_next_state := PeakDetect;
--					
--				when "0110" =>
--					dpasp_next_state := EchoCombLowPass;
--					next_dest <= recv.data(23 downto 20);
--					Parameters <= recv.data(15 downto 0);
--				when "0111" =>
--					dpasp_next_state := EchoAllPass;
--					next_dest <= recv.data(23 downto 20);
--					Parameters <= recv.data(15 downto 0);

--				when "1000" =>
--					dpasp_next_state := RoomSimulator;
--					next_dest <= recv.data(23 downto 20);
--					Parameters <= recv.data(15 downto 0);

--				when others =>
					-- Go back to Reset state
--					dpasp_state <= dpasp_next_state;
--				end case;
--					-- Do Nothing
--				end case;
--			else
--				-- If in Direct then stay Direct, otherwise return to default state Idle
--				if dpasp_state = Direct then
--					dpasp_next_state := Direct;
--				else
--					dpasp_next_state := Idle;
--				end if;
--			end if;
--			
--			-- Change behaviour based on current state
--			case dpasp_state is
--				when Reset =>
--					-- Reset all completion signals
--						enable_allpass  <= '0';
--						enable_comb  <= '0';
--						enable_room <= '1';
--						
--						reset_allpass <= '1';
--						reset_comb <= '1';
--						reset_room <= '0';

--					Gain_comp <= "00000000000000" & recv.data(15 downto 14);
--					Gain_comp_SECOND <= "00000000000000" & recv.data(13 downto 12);
--					size_input <=  recv.data(11 downto 0);
						
--						output_sel <= "00";
--					dpasp_state <= dpasp_next_state;
--				when Idle =>
--					dpasp_state <= dpasp_next_state;
--					
--				when Direct =>		
--		
--					enable_allpass  <= '0';
--					enable_comb  <= '0';
--					enable_room <= '0';
--					
--					reset_allpass <= '1';
--					reset_comb <= '1';
--					reset_room <= '1';
--					
--					output_sel <= "11";
--					
--				when EchoCombLowPass =>
--	
--					enable_allpass  <= '0';
--					enable_comb  <= '1';
--					enable_room <= '0';

--					Gain_comp <= "00000000000000" & Parameters(15 downto 14);
--					Gain_comp_SECOND <= "00000000000000" & Parameters(13 downto 12);
--					size_input <= Parameters(11 downto 0)
--					
--					
--					reset_allpass <= '1';
--					reset_comb <= '0';
--					reset_room <= '1';
--					output_sel <= "10";
--				
--				when EchoAllPass =>
--
--					enable_allpass  <= '1';
--					enable_comb  <= '0';
--					enable_room <= '0';

--					Gain_comp <= "00000000000000" & Parameters(15 downto 14);
--					Gain_comp_SECOND <= "00000000000000" & rParameters(13 downto 12);
--					size_input <= Parameters(11 downto 0)
--					
--					reset_allpass <= '0';
--					reset_comb <= '1';
--					reset_room <= '1';
--					output_sel <= "01";
--					
--					
--				when RoomSimulator =>
--					enable_allpass  <= '0';
--					enable_comb  <= '0';
--					enable_room <= '1';

--					Gain_comp <= Parameters(15 downto 14);
--					Gain_comp_SECOND <= Parameters(13 downto 12);
--					size_input <= Parameters(11 downto 0)
--					
--					reset_allpass <= '1';
--					reset_comb <= '1';
--					reset_room <= '0';
--					output_sel <= "00";
--					
--				when others =>
--					-- Go back to Reset state
--					dpasp_state <= Reset;
--				end case;
--		end if;
--	end process fsm;

end architecture control;



