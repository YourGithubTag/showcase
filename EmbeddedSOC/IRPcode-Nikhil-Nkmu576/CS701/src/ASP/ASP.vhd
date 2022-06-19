-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
-- CREATED		"Sun Jun 13 20:04:17 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ASP IS 
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
END ASP;

ARCHITECTURE bdf_type OF ASP IS 

COMPONENT roomsimlatorblock
	PORT(VALIDL : IN STD_LOGIC;
		 VALIDR : IN STD_LOGIC;
		 CLK_IN : IN STD_LOGIC;
		 ENABLE : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 DATA_IN_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DATA_IN_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_SECOND : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 size_input : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT allpassechoblock
	PORT(VALIDL : IN STD_LOGIC;
		 VALIDR : IN STD_LOGIC;
		 CLK_IN : IN STD_LOGIC;
		 ENABLESIMPLE : IN STD_LOGIC;
		 RESETSIMP : IN STD_LOGIC;
		 DATA_IN_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DATA_IN_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAINCOMPLEX : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAINCOMPLEX_SECOND : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 size_input : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT combecholowpassblock
	PORT(VALIDL : IN STD_LOGIC;
		 VALIDR : IN STD_LOGIC;
		 CLK_IN : IN STD_LOGIC;
		 ENABLESIMPLE : IN STD_LOGIC;
		 RESETSIMP : IN STD_LOGIC;
		 DATA_IN_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DATA_IN_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAINCOMPLEX : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAINCOMPLEX_SECOND : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 size_input : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux4to1
	PORT(clk : IN STD_LOGIC;
		 input_1 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 input_2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 input_3 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 input_4 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 output_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT demux
	PORT(clk : IN STD_LOGIC;
		 inputData : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 output_L : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output_R : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	enable_allpass :  STD_LOGIC;
SIGNAL	enable_comb :  STD_LOGIC;
SIGNAL	enable_room :  STD_LOGIC;
SIGNAL	Gain_comp :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_comp_SECOND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	input_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	input_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	output_sel :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	reset_allpass :  STD_LOGIC;
SIGNAL	reset_comb :  STD_LOGIC;
SIGNAL	reset_room :  STD_LOGIC;
SIGNAL	size :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	VALIDINPUTL :  STD_LOGIC;
SIGNAL	VALIDINPUTR :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(16 DOWNTO 0);


BEGIN 



b2v_inst : roomsimlatorblock
PORT MAP(VALIDL => VALIDINPUTL,
		 VALIDR => VALIDINPUTR,
		 CLK_IN => CLK_IN,
		 ENABLE => enable_room,
		 RESET => reset_room,
		 DATA_IN_1 => input_1,
		 DATA_IN_2 => input_2,
		 GAIN => Gain_comp,
		 GAIN_SECOND => Gain_comp_SECOND,
		 size_input => size,
		 Output => SYNTHESIZED_WIRE_0);


b2v_inst14 : allpassechoblock
PORT MAP(VALIDL => VALIDINPUTL,
		 VALIDR => VALIDINPUTR,
		 CLK_IN => CLK_IN,
		 ENABLESIMPLE => enable_allpass,
		 RESETSIMP => reset_allpass,
		 DATA_IN_1 => input_1,
		 DATA_IN_2 => input_2,
		 GAINCOMPLEX => Gain_comp,
		 GAINCOMPLEX_SECOND => Gain_comp_SECOND,
		 size_input => size,
		 Output => SYNTHESIZED_WIRE_1);


b2v_inst15 : combecholowpassblock
PORT MAP(VALIDL => VALIDINPUTL,
		 VALIDR => VALIDINPUTR,
		 CLK_IN => CLK_IN,
		 ENABLESIMPLE => enable_comb,
		 RESETSIMP => reset_comb,
		 DATA_IN_1 => input_1,
		 DATA_IN_2 => input_2,
		 GAINCOMPLEX => Gain_comp,
		 GAINCOMPLEX_SECOND => Gain_comp_SECOND,
		 size_input => size,
		 Output => SYNTHESIZED_WIRE_2);


b2v_inst19 : mux4to1
PORT MAP(clk => CLK_IN,
		 input_1 => SYNTHESIZED_WIRE_0,
		 input_2 => SYNTHESIZED_WIRE_1,
		 input_3 => SYNTHESIZED_WIRE_2,
		 input_4 => DATA_IN,
		 output_sel => output_sel,
		 Output => output);


b2v_inst6 : demux
PORT MAP(clk => CLK_IN,
		 inputData => DATA_IN,
		 output_L => input_1,
		 output_R => input_2);

VALIDINPUTL <= VALIDL;
VALIDINPUTR <= VALIDR;
enable_room <= ENABLEROOM;
reset_room <= RESETROOM;
Gain_comp <= GAINCOMPLEX;
Gain_comp_SECOND <= GAINCOMPLEX_SECOND;
size <= size_input;
enable_allpass <= ENABLEALLPASS;
reset_allpass <= RESETALLPASS;
enable_comb <= ENABLECOMB;
reset_comb <= RESETCOMB;
output_sel <= OUTPUTSEL;

END bdf_type;