-- Copyright (c) 2020, Dave Renzo
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
    -- * Redistributions of source code must retain the above copyright
      -- notice, this list of conditions and the following disclaimer.
    -- * Redistributions in binary form must reproduce the above copyright
      -- notice, this list of conditions and the following disclaimer in the
      -- documentation and/or other materials provided with the distribution.
    -- * Neither the name of the <organization> nor the
      -- names of its contributors may be used to endorse or promote products
      -- derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--Designer: Dave Renzo
--File Name: LCD_DRIVER_TB.vhd
--Description: Test bench for the lcd driver project
--
--CHANGELOG:
--2/25/20   : Created
--


--LIBRRARY DECLARATIONS
library ieee;
use ieee.std_logic_1164.all;

--ENTITY
ENTITY LCD_DRIVER_TB IS
END ENTITY;


ARCHITECTURE test of LCD_DRIVER_TB is

---------ENUMERATED TYPES-------------------------------------------


--------CONSTANTS---------------------------------------------------
constant clock_period : time := 20 ns;

----------SIGNALS---------------------------------------------------
SIGNAL sCLK_TB      : STD_LOGIC:='0';
SIGNAL sRESET_N_TB  : STD_LOGIC:='0';
SIGNAL sDISP_ON     : STD_LOGIC:='0';

BEGIN
    
-----------CONCURRENT STATEMENTS------------------------------------


----------COMPONENT INSTANTIATION-----------------------------------
UUT : entity work.LCD_DRIVER(struct)
port map(
            iCLK        => sCLK_TB,            
            iRST_N      => sRESET_N_TB,    
            iVIDEO_ON   => sDISP_ON);   

----------PROCESSES-------------------------------------------------
--Generate 50Mhz Test Clock
clock_process : process
  begin
    sCLK_TB <= '0';
    wait for clock_period/2;
    sCLK_TB <= '1';
    wait for clock_period/2;
end process;
		
--test stimulus
stimulus : process
  begin
    wait for clock_period * 2;
    sRESET_N_TB <= '1';
    sDISP_ON <= '1';
    wait for clock_period * 100;
    wait;
  end process;		
		
		
END test;
    