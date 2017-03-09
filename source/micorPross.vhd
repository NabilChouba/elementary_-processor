----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nabil Chouba
-- 
-- Create Date:    12:23:19 12/30/2009 
-- Design Name: 
-- Module Name:    micorPross - RTL 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity micorPross is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  MemRW_IO : out  STD_LOGIC;
			  MemAddr_IO : out  STD_LOGIC_VECTOR (7 downto 0);
           MemD_IO : out  STD_LOGIC_VECTOR (15 downto 0)
           --MemQ_IO : in  STD_LOGIC_VECTOR (15 downto 0)
			  );


end micorPross;

architecture RTL of micorPross is

component ctr 
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  zflag  : in STD_LOGIC;
           opCode : in  STD_LOGIC_VECTOR (7 downto 0);
           muxPC : out  STD_LOGIC;
           muxMAR : out  STD_LOGIC;
           muxACC : out  STD_LOGIC;
           loadMAR : out  STD_LOGIC;
           loadPC : out  STD_LOGIC;
           loadACC : out  STD_LOGIC;
           loadMDR : out  STD_LOGIC;
           loadIR : out  STD_LOGIC;
           opALU : out  STD_LOGIC;
           MemRW : out  STD_LOGIC
           );
end component;

component datapath 
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           muxPC : in  STD_LOGIC;
           muxMAR : in  STD_LOGIC;
           muxACC : in  STD_LOGIC;
           loadMAR : in  STD_LOGIC;
           loadPC : in  STD_LOGIC;
           loadACC : in  STD_LOGIC;
           loadMDR : in  STD_LOGIC;
           loadIR : in  STD_LOGIC;
           opALU : in  STD_LOGIC;
			  zflag  : out STD_LOGIC;
			  opCode  : out  STD_LOGIC_VECTOR (7 downto 0);
           MemAddr : out  STD_LOGIC_VECTOR (7 downto 0);
           MemD : out  STD_LOGIC_VECTOR (15 downto 0);
           MemQ : in  STD_LOGIC_VECTOR (15 downto 0));
end component;

component ram  
generic( d_width    : integer ; 
         addr_width : integer ; 
         mem_depth  : integer 
        ); 
port (
      clk      : in STD_LOGIC;
      we       : in STD_LOGIC;
      d        : in STD_LOGIC_VECTOR(d_width - 1 downto 0); 
      q        : out STD_LOGIC_VECTOR(d_width - 1 downto 0); 
      addr     : in unsigned(addr_width - 1 downto 0)
      
      ); 
end component; 

signal muxPC   : STD_LOGIC;
signal muxMAR  : STD_LOGIC;
signal muxACC  : STD_LOGIC;
signal loadMAR : STD_LOGIC;
signal loadPC  : STD_LOGIC;
signal loadACC : STD_LOGIC;
signal loadMDR : STD_LOGIC;
signal loadIR  : STD_LOGIC;
signal opALU   : STD_LOGIC;
signal opCode  : STD_LOGIC_VECTOR (7 downto 0);
signal MemAddr : STD_LOGIC_VECTOR (7 downto 0);
signal MemD    : STD_LOGIC_VECTOR (15 downto 0);
signal MemQ    : STD_LOGIC_VECTOR (15 downto 0);
signal MemRW   : STD_LOGIC;
signal zflag  :  STD_LOGIC;
			  
begin

 U_Memory: ram 
 generic map (d_width   =>  16,
              addr_width => 8,
              mem_depth  => 256) 
 PORT MAP (
      clk => clk, 
		we  =>MemRW ,
      d   =>MemD ,
		q   =>MemQ ,
      addr=>unsigned(MemAddr)
     );   

 u_ctr : ctr 
 port map (clk => clk, 
           rst => rst,
			  zflag => zflag,
           opCode => opCode,
           muxPC  => muxPC,
           muxMAR => muxMAR,
           muxACC => muxACC,
           loadMAR=> loadMAR,
           loadPC => loadPC,
           loadACC=> loadACC,
           loadMDR=> loadMDR,
           loadIR => loadIR,
           opALU  => opALU,
           MemRW  => MemRW
			  );



 u_datapath : datapath 
 port map (clk => clk, 
           rst => rst,
           opCode => opCode,
           muxPC  => muxPC,
           muxMAR => muxMAR,
           muxACC => muxACC,
           loadMAR=> loadMAR,
           loadPC => loadPC,
           loadACC=> loadACC,
           loadMDR=> loadMDR,
           loadIR => loadIR,
			  zflag => zflag,
           opALU  => opALU,
			  MemAddr =>MemAddr,
           MemD =>MemD,
           MemQ =>MemQ
			   );

 MemAddr_IO <= MemAddr;
 MemD_IO    <= MemD;
 MemRW_IO   <= MemRW;

end RTL;

