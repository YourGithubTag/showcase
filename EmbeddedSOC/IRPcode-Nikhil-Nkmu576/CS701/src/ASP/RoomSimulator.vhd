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
-- CREATED		"Sun Jun 13 19:05:07 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY RoomSimulator IS 
	PORT
	(
		CLK_In :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		VALID :  IN  STD_LOGIC;
		GainDown :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		GainSECONDDown :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		InputData :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END RoomSimulator;

ARCHITECTURE bdf_type OF RoomSimulator IS 

COMPONENT allpasstest
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

COMPONENT divider
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 input_shift : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT addition
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 inputA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 inputB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT gainsetter
	PORT(clk : IN STD_LOGIC;
		 gain_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_5 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 GAIN_6 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	enableW :  STD_LOGIC;
SIGNAL	Gain_In :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_In_SECOND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_5 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GAIN_OUT_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	resetW :  STD_LOGIC;
SIGNAL	VALIDW :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 



b2v_inst : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => InputData,
		 Output => SYNTHESIZED_WIRE_22);


b2v_inst14 : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => SYNTHESIZED_WIRE_22,
		 Output => SYNTHESIZED_WIRE_23);


b2v_inst15 : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => SYNTHESIZED_WIRE_23,
		 Output => SYNTHESIZED_WIRE_26);


b2v_inst16 : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => SYNTHESIZED_WIRE_24,
		 Output => SYNTHESIZED_WIRE_10);


b2v_inst17 : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => SYNTHESIZED_WIRE_25,
		 Output => SYNTHESIZED_WIRE_24);


b2v_inst18 : allpasstest
PORT MAP(CLK_In => CLK_In,
		 reset => resetW,
		 enable => enableW,
		 VALID => VALIDW,
		 GainDown => Gain_In,
		 GainSECONDDown => Gain_In_SECOND,
		 InputData => SYNTHESIZED_WIRE_26,
		 Output => SYNTHESIZED_WIRE_25);


b2v_inst19 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_22,
		 input_shift => GAIN_OUT_1,
		 output => SYNTHESIZED_WIRE_17);


b2v_inst20 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_23,
		 input_shift => GAIN_OUT_2,
		 output => SYNTHESIZED_WIRE_18);


b2v_inst21 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_26,
		 input_shift => GAIN_OUT_3,
		 output => SYNTHESIZED_WIRE_12);


b2v_inst22 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_25,
		 input_shift => GAIN_OUT_4,
		 output => SYNTHESIZED_WIRE_14);


b2v_inst23 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_24,
		 input_shift => GAIN_OUT_5,
		 output => SYNTHESIZED_WIRE_13);


b2v_inst24 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_10,
		 input_shift => GAIN_OUT_6,
		 output => SYNTHESIZED_WIRE_15);


b2v_inst25 : addition
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_11,
		 inputB => SYNTHESIZED_WIRE_12,
		 output => SYNTHESIZED_WIRE_19);


b2v_inst26 : addition
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_13,
		 inputB => SYNTHESIZED_WIRE_14,
		 output => SYNTHESIZED_WIRE_16);


b2v_inst27 : addition
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_15,
		 inputB => SYNTHESIZED_WIRE_16,
		 output => SYNTHESIZED_WIRE_20);


b2v_inst28 : addition
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_17,
		 inputB => SYNTHESIZED_WIRE_18,
		 output => SYNTHESIZED_WIRE_11);


b2v_inst29 : addition
PORT MAP(clk => VALIDW,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_19,
		 inputB => SYNTHESIZED_WIRE_20,
		 output => SYNTHESIZED_WIRE_21);


b2v_inst30 : gainsetter
PORT MAP(clk => CLK_In,
		 gain_in => Gain_In,
		 GAIN_1 => GAIN_OUT_1,
		 GAIN_2 => GAIN_OUT_2,
		 GAIN_3 => GAIN_OUT_3,
		 GAIN_4 => GAIN_OUT_4,
		 GAIN_5 => GAIN_OUT_5,
		 GAIN_6 => GAIN_OUT_6);


b2v_inst31 : addition
PORT MAP(clk => VALIDW,
		 enable => enableW,
		 inputA => InputData,
		 inputB => SYNTHESIZED_WIRE_21,
		 output => OUTPUT);

VALIDW <= VALID;
enableW <= enable;
resetW <= reset;
Gain_In <= GainDown;
Gain_In_SECOND <= GainSECONDDown;

END bdf_type;