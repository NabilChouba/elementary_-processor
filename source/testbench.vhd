
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:50:30 12/30/2009
-- Design Name:   micorPross
-- Module Name:   C:/Xilinx92i/ElementaryProcessor/testbench.vhd
-- Project Name:  ElementaryProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: micorPross
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testbench_vhd IS
END testbench_vhd;

ARCHITECTURE behavior OF testbench_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT micorPross
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		MemRW_IO : OUT std_logic;
		MemAddr_IO : OUT std_logic_vector(7 downto 0);
		MemD_IO : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '1';

	--Outputs
	SIGNAL MemRW_IO :  std_logic;
	SIGNAL MemAddr_IO :  std_logic_vector(7 downto 0);
	SIGNAL MemD_IO :  std_logic_vector(15 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: micorPross PORT MAP(
		clk => clk,
		rst => rst,
		MemRW_IO => MemRW_IO,
		MemAddr_IO => MemAddr_IO,
		MemD_IO => MemD_IO
	);

  rst<='0' AFTER 200 NS;
  clk <= not clk AFTER 50 NS;
  
  
	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
