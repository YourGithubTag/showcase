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
-- CREATED		"Sun Jun 13 19:05:26 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ALLPASSTEST IS 
	PORT
	(
		CLK_In :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		VALID :  IN  STD_LOGIC;
		GainDown :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		GainSECONDDown :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		InputData :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Output :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ALLPASSTEST;

ARCHITECTURE bdf_type OF ALLPASSTEST IS 

COMPONENT delay_line
GENERIC (L : INTEGER;
			W : INTEGER
			);
	PORT(i_clk : IN STD_LOGIC;
		 i_sync_reset : IN STD_LOGIC;
		 i_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 o_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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

COMPONENT negdivider
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 input_shift : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	enableW :  STD_LOGIC;
SIGNAL	FB_In :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_In :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Gain_In_SECOND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	resetW :  STD_LOGIC;
SIGNAL	VALIDW :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 



b2v_inst : delay_line
GENERIC MAP(L => 3072,
			W => 16
			)
PORT MAP(i_clk => VALIDW,
		 i_sync_reset => resetW,
		 i_data => SYNTHESIZED_WIRE_5,
		 o_data => SYNTHESIZED_WIRE_6);


b2v_inst1 : divider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_6,
		 input_shift => Gain_In,
		 output => FB_In);


b2v_inst5 : addition
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 inputA => InputData,
		 inputB => FB_In,
		 output => SYNTHESIZED_WIRE_5);


b2v_inst6 : negdivider
PORT MAP(clk => CLK_In,
		 enable => enableW,
		 input => SYNTHESIZED_WIRE_5,
		 input_shift => Gain_In,
		 output => SYNTHESIZED_WIRE_3);


b2v_inst7 : addition
PORT MAP(clk => VALIDW,
		 enable => enableW,
		 inputA => SYNTHESIZED_WIRE_3,
		 inputB => SYNTHESIZED_WIRE_6,
		 output => Output);

VALIDW <= VALID;
enableW <= enable;
resetW <= reset;
Gain_In <= GainDown;

END bdf_type;