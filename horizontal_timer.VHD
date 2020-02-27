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
--File Name: horizontal_timer.vhd
--Description: FSM to generate horizontal video timing for 40pin RGB LCD
--MODULE
--
--CHANGELOG:
--2/24/15   : Created
--2/25/20   : Added 3 clause BSD License, cleaned up code, 
--          : refactored design to use numeric_std 
--


--LIBRRARY DECLARATIONS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.LCD_Video_Timing_Parameters_PKG.all;


--ENTITY
ENTITY horizontal_timer IS
    PORT(   --inputs
            iCLK            :   IN STD_LOGIC;
            iRST_N          :   IN STD_LOGIC;
            iVIDEO_ON       :   IN STD_LOGIC;
            iCLK_enable     :   IN STD_LOGIC;
            iframe_act      :   IN STD_LOGIC;
            --outputs
            oLine_Enable	:	OUT STD_LOGIC;
			oDEN            :   OUT STD_LOGIC;
            oActive_X_Cnt   :   OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            oHsync_n        :   OUT STD_LOGIC);
END ENTITY;


ARCHITECTURE rtl of horizontal_timer is

---------ENUMERATED TYPES-------------------------------------------
TYPE STATE_TYPE IS (IDLE, H_SYNC, H_FRONT_PORCH, H_BACK_PORCH, H_ACTIVE);

--------CONSTANTS---------------------------------------------------


----------SIGNALS---------------------------------------------------
--signals for states
SIGNAL state            :STATE_TYPE;
SIGNAL Hsync_n          :STD_LOGIC;
SIGNAL DEN              :STD_LOGIC;
SIGNAL active_x_cnt     :unsigned(11 DOWNTO 0):=x"000";
SIGNAL Hor_timer    	:integer range 0 to 4095;
SIGNAL Line_Enable   	:STD_LOGIC;

BEGIN
    
-----------CONCURRENT STATEMENTS------------------------------------
oLine_Enable <= Line_Enable;

    
----------PROCESSES-------------------------------------------------

Hor_Timer_State_Diagram_Single_Process: process (iCLK,iRST_n) --sensitive only to clock and reset
begin
	if (iRST_n = '0') then
		state <= idle;
		hor_timer <= 0;
		active_x_cnt <= x"000";
		hsync_n <= '1';
		line_enable <= '0';
		den <= '0';
	--implement state diagram
	elsif (rising_edge(iCLK)) then
		line_enable <= '0';     --line enable is clock enable to vertical timer, high for only one 50Mhz clock 
		if (iCLK_ENABLE ='1') then
		--default signal assignments at PCLK frequency
		hsync_n <= '1'; 	    --Default for hsync is to be off
		state <= idle;	        --Default state of state machine is to be IDLE
		active_x_cnt <= x"000"; --Default state of active_x_cont is x"000"
		hor_timer <= 0;	        --Default state of horizontal timer is to be off or 0
		den <= '0';
		case state is
			when idle =>
				if (iVIDEO_ON='1') then 
					state <= h_sync;
					hor_timer <= c_Hsync_Pulse_Width - 1;
					hsync_n <= '0'; 	--assert hsync_n active low
					line_enable <= '1';
				else 
					state <= idle; 
				end if;
			when h_sync =>
				if (hor_timer > 0) then 
					hor_timer <= hor_timer - 1;
					hsync_n <= '0';
					state <= h_sync;
				else 
					hor_timer <= c_Hsync_Back_Porch -1;
					state <= h_back_porch;
				end if;
			when h_back_porch =>
				if (hor_timer > 0) then 
					hor_timer <= hor_timer - 1;
					state <= h_back_porch;
				else 
					hor_timer <= c_Active_Pclks_Line -1;
					state <= h_active;
					if (iFRAME_ACT='1') then 
						active_x_cnt <= active_x_cnt + 1;
						den <= '1';
					end if;
				end if;
			when h_active =>
				if (hor_timer > 0) then 
					hor_timer <= hor_timer - 1;
					state <= h_active;
					if (iFRAME_ACT='1') then 
						active_x_cnt <= active_x_cnt + 1;
						den <= '1';
					end if;
				else 
					hor_timer <= c_Hsync_Front_Porch -1;
					state <= h_front_porch;
				end if;
			when h_front_porch =>
				if (hor_timer > 0) then 
					hor_timer <= hor_timer -1;
					state <= h_front_porch;
				else 
					state <= h_sync;
					hsync_n <= '0';
					line_enable <= '1';
					hor_timer <= c_Hsync_Pulse_Width - 1;
				end if;
			when others =>
				state <= idle; --redundant because of default assignments but not harmful
			end case;
		end if;	--end of clock enable block
	end if;	--end of clock block
end process Hor_Timer_State_Diagram_Single_Process;
		
reg_outputs: process (iCLK,iRST_n)
BEGIN
    if rising_edge(iCLK) then		
		oDeN <= DEn;
        oactive_X_Cnt<= std_logic_vector(active_x_cnt);
        oHsync_n<=Hsync_n; 
    end if;
END PROCESS;
END rtl;
    