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
-- CREATED		"Sun Jun 13 19:04:16 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CombEchoLowPassBlock IS 
	PORT
	(
		CLK_IN :  IN  STD_LOGIC;
		ENABLESIMPLE :  IN  STD_LOGIC;
		RESETSIMP :  IN  STD_LOGIC;
		VALIDL :  IN  STD_LOGIC;
		VALIDR :  IN  STD_LOGIC;
		DATA_IN_1 :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA_IN_2 :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		GAINCOMPLEX :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		GAINCOMPLEX_SECOND :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Output :  OUT  STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END CombEchoLowPassBlock;

ARCHITECTURE bdf_type OF CombEchoLowPassBlock IS 

COMPONENT lowpassechotest
	PORT(CLK_In : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 VALID : IN STD_LOGIC;
		 GainDown : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GainSECONDDown : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 InputData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT lrdiff
	PORT(clk : IN STD_LOGIC;
		 out_selL : IN STD_LOGIC;
		 out_selR : IN STD_LOGIC;
		 input_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 input_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	enable_echosimple :  STD_LOGIC;
SIGNAL	Gain_comp :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_comp_SECOND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	input_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	input_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	reset_echosimp :  STD_LOGIC;
SIGNAL	VALIDINPUTL :  STD_LOGIC;
SIGNAL	VALIDINPUTR :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 



b2v_inst : lowpassechotest
PORT MAP(CLK_In => CLK_IN,
		 reset => reset_echosimp,
		 enable => enable_echosimple,
		 VALID => VALIDINPUTL,
		 GainDown => Gain_comp,
		 GainSECONDDown => Gain_comp_SECOND,
		 InputData => input_1,
		 Output => SYNTHESIZED_WIRE_0);


b2v_inst1 : lrdiff
PORT MAP(clk => CLK_IN,
		 out_selL => VALIDINPUTL,
		 out_selR => VALIDINPUTR,
		 input_1 => SYNTHESIZED_WIRE_0,
		 input_2 => SYNTHESIZED_WIRE_1,
		 Output => Output);


b2v_inst11 : lowpassechotest
PORT MAP(CLK_In => CLK_IN,
		 reset => reset_echosimp,
		 enable => enable_echosimple,
		 VALID => VALIDINPUTR,
		 GainDown => Gain_comp,
		 GainSECONDDown => Gain_comp_SECOND,
		 InputData => input_2,
		 Output => SYNTHESIZED_WIRE_1);

VALIDINPUTL <= VALIDL;
VALIDINPUTR <= VALIDR;
reset_echosimp <= RESETSIMP;
enable_echosimple <= ENABLESIMPLE;
Gain_comp <= GAINCOMPLEX;
Gain_comp_SECOND <= GAINCOMPLEX_SECOND;
input_1 <= DATA_IN_1;
input_2 <= DATA_IN_2;

END bdf_type;