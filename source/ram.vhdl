-------------------------------------------------------------------------------- 
-- Create Date   :    25/08/2008 
-- Design Name   :    Ram 
-- Developped by :    Nabil CHOUBA

-- Description   :    asyncro Module Ram port generic.  
-------------------------------------------------------------------------------- 

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 

entity ram is 
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
end ram; 

architecture RAM_arch of ram is 

type mem_type is array (mem_depth - 1 downto 0) of  STD_LOGIC_VECTOR (d_width - 1 downto 0); 



signal mem : mem_type ; 
 
begin


 




  wr_port : process ( clk )
      begin
-- active only at simulation
-- must be desactivated on synthesis
--         
--        if mem(0) /= x"0A01" then 
--			  mem(0) <= x"0B03"; -- LOAD  11
--			  mem(1) <= x"0C01"; -- ADD   12
--			  mem(2) <= x"0D04"; -- STORE 13
--	        mem(3) <= x"0A02"; -- XOR   10
--			  mem(4) <= x"0706"; -- JUMPZ 7
--			  mem(5) <= x"0D03"; -- LOAD  13
--	        mem(6) <= x"0105"; -- JUMP  7
--			
--		     mem(7) <= x"0705"; -- JUMPZ 7
--			
--			  mem(10) <= x"0008";-- A data = 8
--			  mem(11) <= x"0002";-- B data = 2
--			  mem(12) <= x"0001";-- C data = 1
--			                     -- D data = ACC
--			  
--			end if;

        if   (clk'event and clk = '1') then
   		  if ( we    = '1') then
                mem(conv_integer(addr)) <= d;
           
            end if;
			end if;
    end process wr_port ;

  
  q <= mem(conv_integer(addr)) ;
  
end RAM_arch; 
