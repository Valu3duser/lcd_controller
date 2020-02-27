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
--File Name: LCD_DRIVER.vhd
--Description: top level structural design of 40 pin rgb controller
--
--CHANGELOG:
--2/25/20   : Created
--


--LIBRRARY DECLARATIONS
library ieee;
use ieee.std_logic_1164.all;



--ENTITY
ENTITY LCD_DRIVER IS
    PORT(   --inputs
            iCLK            :   IN STD_LOGIC;
            iRST_N          :   IN STD_LOGIC;
            iVIDEO_ON       :   IN STD_LOGIC;
            oDEN            :   OUT STD_LOGIC;
            oHSYNC          :   OUT STD_LOGIC;
            oVSYNC          :   OUT STD_LOGIC;
            oRED            :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            oGREEN          :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            oBLUE           :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
            
END ENTITY;


ARCHITECTURE struct of LCD_DRIVER is

---------ENUMERATED TYPES-------------------------------------------


--------CONSTANTS---------------------------------------------------


----------SIGNALS---------------------------------------------------
SIGNAL sPCLK            : STD_LOGIC;
SIGNAL sNCLK            : STD_LOGIC;
SIGNAL sLINE_ENABLE     : STD_LOGIC;
SIGNAL sDEN             : STD_LOGIC;
SIGNAL sACTIVE_X_CNT    : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL sACTIVE_Y_CNT    : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL sH_SYNC          : STD_LOGIC;
SIGNAL sV_SYNC          : STD_LOGIC;
SIGNAL sFRAME_ACTIVE    : STD_LOGIC;

BEGIN
    
-----------CONCURRENT STATEMENTS------------------------------------

    
----------PROCESSES-------------------------------------------------


----------COMPONENT INSTANTIATION-----------------------------------
pixel_clk : entity work.PIXEL_CLOCK_GENERATOR(rtl)
port map(
            CLK     => iCLK,
            RESET_N => iRST_N,
            Q       => sPCLK,
            Q_N     => sNCLK);

h_timer : entity work.horizontal_timer(rtl)
port map(   iCLK            => iCLK,
            iRST_N          => iRST_N,
            iVIDEO_ON       => iVIDEO_ON,
            iCLK_enable     => sPCLK,
            iframe_act      => sFRAME_ACTIVE,
            --outputs
            oLine_Enable	=> sLINE_ENABLE,
			oDEN            => sDEN,
            oActive_X_Cnt   => sACTIVE_X_CNT,
            oHsync_n        => sH_SYNC);

v_timer : entity work.vertical_timer(rtl)    
port map(
            iCLK            => iCLK,
            iRST_N          => iRST_N,
            iVIDEO_ON       => iVIDEO_ON,
            iCLK_enable     => sLINE_ENABLE,
            
            --outputs
            oFrame_Active	=> sFRAME_ACTIVE,
			oActive_Y_Cnt   => sACTIVE_Y_CNT,
            oVsync_n        => sV_SYNC);
    
pattern_gen : entity work.pattern_generator(rtl)
port map(
            iCLK			=> iCLK,
			iRST_n			=> iRST_N,
			iCLK_ENABLE		=> sPCLK,
			active_x_cnt 	=> sACTIVE_X_CNT,
			active_y_cnt 	=> sACTIVE_Y_CNT,
			frame_active	=> sFRAME_ACTIVE,
			line_active		=> sDEN,
			iHD				=> sH_SYNC,
			iVD				=> sV_SYNC,
            iDEN            => sDEN,
			oHD				=> oHSYNC,
			oVD				=> oVSYNC,
			oDEN			=> oDEN,
			oLCD_R			=> oRED,
			oLCD_G			=> oGREEN,
			oLCD_B			=> oBLUE,
			iVIDEO_ON		=> iVIDEO_ON,
			iLine_en	    => sLINE_ENABLE);
		
		
		
END struct;
    