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


entity ctr is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  zflag  : in STD_LOGIC;
           opCode : in  STD_LOGIC_VECTOR (7 downto 0);
           muxPC  : out  STD_LOGIC;
           muxMAR : out  STD_LOGIC;
           muxACC : out  STD_LOGIC;
           loadMAR: out  STD_LOGIC;
           loadPC : out  STD_LOGIC;
           loadACC: out  STD_LOGIC;
           loadMDR: out  STD_LOGIC;
           loadIR : out  STD_LOGIC;
           opALU  : out  STD_LOGIC;
           MemRW  : out  STD_LOGIC
           );
end ctr;

architecture RTL of ctr is


  -- FSM States
   type state_type is (Fetch_1,Fetch_2,Fetch_3,Decode,ExecADD_1,ExecADD_2,ExecOR_1,ExecOR_2,ExecLoad_1,ExecLoad_2,ExecStore_1,ExecStore_2,ExecJump);
  -- FSM registers
  signal state_reg : state_type;
  signal state_next: state_type;

-- Instruction definitions
	constant op_add        : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
	constant op_or         : STD_LOGIC_VECTOR (7 downto 0) := "00000010";
	constant op_load       : STD_LOGIC_VECTOR (7 downto 0) := "00000011";
	constant op_store      : STD_LOGIC_VECTOR (7 downto 0) := "00000100";
	constant op_jump       : STD_LOGIC_VECTOR (7 downto 0) := "00000101";
	constant op_jumpz      : STD_LOGIC_VECTOR (7 downto 0) := "00000110";

-- ALU opertion definitions		
	constant alu_add      : STD_LOGIC := '0';
	constant alu_or       : STD_LOGIC := '1';

begin

 cloked_process : process( clk, rst )
 Begin
   if( rst='1' ) then
     state_reg <=  Fetch_1 ;
   elsif( clk'event and clk='1' ) then
     state_reg<= state_next ;
   end if;
 end process ;

 --next state processing
  combinatory_FSM_next :
  process(state_reg,opcode,zflag)
  begin
    state_next<= state_reg;

    case state_reg is
      when Fetch_1 =>	 
        state_next <= Fetch_2;  
      when Fetch_2 =>	 
        state_next <= Fetch_3;  
      when Fetch_3 =>	 
        state_next <= decode;  
      when decode =>	 
		  case opcode is
		     when op_add =>	
			    state_next <= ExecADD_1;  
			  when op_or =>	 
			    state_next <= ExecOR_1;  
			  when op_load =>	
             state_next <= ExecLoad_1;  			  
			  when op_store =>	 
             state_next <= ExecStore_1;  			  
			  when op_jump =>	 
             state_next <= ExecJump;  
			  when op_jumpz =>	 
			    state_next <= Fetch_1;  
			    if zflag = '1' then
               state_next <= ExecJump;  
				 end if;
				 
           when others =>
        end case;				 

      when ExecADD_1 =>	 
        state_next <= ExecADD_2;  
      when ExecADD_2 =>	 
        state_next <= Fetch_1;  
 
      when ExecOR_1 =>	 
        state_next <= ExecOR_2;  
      when ExecOR_2 =>	 
        state_next <= Fetch_1;  
		  
      when ExecLoad_1 =>	 
        state_next <= ExecLoad_2;  
      when ExecLoad_2 =>	 
        state_next <= Fetch_1;  
		  
      when ExecStore_1 =>	  
        state_next <= Fetch_1;  

      when ExecJump =>	 
        state_next <= Fetch_1;  
        		  
      when others =>
   end case;  
 end process;

 --output processing
  combinatory_output_processing :
  process(state_reg)
  begin
  
    muxPC <= '0'; 
    muxMAR <= '0'; 
    muxACC <= '0'; 
    loadMAR <= '0'; 
    loadPC <= '0'; 
    loadACC <= '0'; 
    loadMDR <= '0'; 
    loadIR <= '0'; 
    opALU <= '0'; 
    MemRW <= '0'; 
	 
    case state_reg is
      when Fetch_1 =>	 
        muxMAR <= '0'; 
		  muxPC  <= '0'; 
		  loadPC <= '1'; 
		  loadMAR<= '1'; 
		  
      when Fetch_2 =>	
        MemRW  <= '0'; 		
        loadMDR<= '1'; 
		  
      when Fetch_3 =>	 
        loadIR<= '1'; 

		  
      when decode =>	 
		  muxMAR  <= '1';
		  loadMAR <= '1';

		  
      when ExecADD_1 =>	 
        MemRW  <= '0'; 
		  loadMDR<= '1'; 
		  
      when ExecADD_2 =>	 
        loadACC <= '1';
		  muxACC  <= '0';
		  opALU   <= '1';
 
 
      when ExecOR_1 =>	 
        MemRW  <= '0'; 
		  loadMDR<= '1'; 

		when ExecOR_2 =>	 
        loadACC <= '1';
		  muxACC  <= '0';
		  opALU   <= '0';
 
 
      when ExecLoad_1 =>	 
        MemRW  <= '0'; 
		  loadMDR<= '1';         
		  
      when ExecLoad_2 =>	 
        loadACC <= '1';        
		  muxACC  <= '1';        
 
		  
      when ExecStore_1 =>	 
		  MemRW  <= '1'; 


      when ExecJump =>	 
        muxPC  <= '1'; 
		  loadPC <= '1'; 
		  
      when others =>

   end case;  
 end process;
end RTL;

