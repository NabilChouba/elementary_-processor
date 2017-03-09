----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nabil Chouba
-- 
-- Create Date:    13:04:29 12/30/2009 
-- Design Name: 
-- Module Name:    datapath - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity datapath is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           muxPC  : in  STD_LOGIC;
           muxMAR : in  STD_LOGIC;
           muxACC : in  STD_LOGIC;
           loadMAR: in  STD_LOGIC;
           loadPC : in  STD_LOGIC;
           loadACC: in  STD_LOGIC;
           loadMDR: in  STD_LOGIC;
           loadIR : in  STD_LOGIC;
           opALU  : in  STD_LOGIC;
			  zflag  : out STD_LOGIC;
			  opCode : out STD_LOGIC_VECTOR (7 downto 0);
           MemAddr: out STD_LOGIC_VECTOR (7 downto 0);
           MemD   : out STD_LOGIC_VECTOR (15 downto 0);
           MemQ   : in  STD_LOGIC_VECTOR (15 downto 0)
			);
end datapath;

architecture RTL of datapath is

  component   alu 
  Port (   A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           opALU : in  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (15 downto 0));
  end component ;

signal  PC_reg       : STD_LOGIC_VECTOR(7 downto 0)  ;  
signal  PC_next      : STD_LOGIC_VECTOR(7 downto 0)  ; 
 
signal  IR_reg      : STD_LOGIC_VECTOR(15 downto 0)  ;  
signal  IR_next      : STD_LOGIC_VECTOR(15 downto 0)  ;  

signal  ACC_reg      : STD_LOGIC_VECTOR(15 downto 0)  ;  
signal  ACC_next      : STD_LOGIC_VECTOR(15 downto 0)  ;  

signal  MDR_reg      : STD_LOGIC_VECTOR(15 downto 0)  ;  
signal  MDR_next      : STD_LOGIC_VECTOR(15 downto 0)  ;  

signal  MAR_reg      : STD_LOGIC_VECTOR(7 downto 0)  ;  
signal  MAR_next      : STD_LOGIC_VECTOR(7 downto 0)  ;  

signal  ALU_out      : STD_LOGIC_VECTOR(15 downto 0)  ;  


begin

cloked_process : process( clk, rst )
  begin
    if( rst='1' ) then
      PC_reg   <= (others=>'0') ;
      IR_reg   <= (others=>'0') ;
      ACC_reg  <= (others=>'0') ;
      MDR_reg  <= (others=>'0') ;
      MAR_reg  <= (others=>'0') ;
		
    elsif( clk'event and clk='1' ) then
      PC_reg   <= PC_next ;
      IR_reg   <= IR_next ;
      ACC_reg  <= ACC_next ;
      MDR_reg  <= MDR_next ;
      MAR_reg  <= MAR_next ;
    end if;
 end process ;

 u_alu : alu 
 port map (  A   => MDR_reg,
             B   => ACC_reg,
				 opALU => opALU,
				 Rout  => ALU_out);

 MDR_next <= MemQ when loadMDR = '1' else
             MDR_reg;
			
 IR_next  <= MDR_reg when loadIR = '1' else
             IR_reg;

 ACC_next <= MDR_reg when loadACC = '1' and muxACC= '1' else
             ALU_out when loadACC = '1' and muxACC= '0' else
	  			 ACC_reg;

 PC_next  <= IR_reg(15 downto 8) when loadPC = '1' and muxPC= '1' else
             PC_reg + 1          when loadPC = '1' and muxPC= '0' else
				 PC_reg;

 MAR_next <= IR_reg(15 downto 8) when loadMAR = '1' and muxMAR= '1' else
             PC_reg              when loadMAR = '1' and muxMAR= '0' else
				 MAR_reg;

 MemAddr  <= MAR_reg;

 MemD     <= ACC_reg;
 
 opCode   <= IR_reg(7 downto 0);

 zflag <= '1' when ACC_reg = "0000000000000000" else
          '0';
end RTL;

