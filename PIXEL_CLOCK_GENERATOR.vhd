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
--File Name: PIXEL_CLOCK_GENERATOR
--Description: This circuit is a divide by two clock divider that generates two
--opposite phase outputs.
--
--CHANGELOG:
--2/24/15   : Created
--2/25/20   : Removed unneaded library declarations.  Added 3-clause BSD license


--LIBRRARY DECLARATIONS
library ieee;
use ieee.std_logic_1164.all;



--ENTITY
ENTITY PIXEL_CLOCK_GENERATOR IS
    PORT(   CLK, RESET_N    :   IN STD_LOGIC; --active low clear
            Q, Q_N          :   OUT STD_LOGIC);
END ENTITY;


ARCHITECTURE rtl of PIXEL_CLOCK_GENERATOR is

----------SIGNALS---------------------------------------------------
SIGNAL s_Q :STD_LOGIC;


BEGIN
-----------CONCURRENT STATEMENTS------------------------------------
    Q_N <= NOT s_Q;
    Q <= s_Q;
    
----------PROCESSES-------------------------------------------------
    
    --PROCESS to infer FF to divide clock by two
    division : PROCESS(CLK)
    BEGIN
        IF(rising_edge(CLK)) THEN
            IF (RESET_N = '0') THEN --synchronus reset
                s_Q <= '0';
            ELSE
                s_Q <= NOT s_Q;
            END IF;
        END IF;
    END PROCESS;
    
END rtl;
    