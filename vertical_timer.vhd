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
--File Name: vertical_timer.vhd
--Description: FSM to generate vertical video timing for terrasic LTM
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
ENTITY vertical_timer IS
    PORT(   --inputs
            iCLK            :   IN STD_LOGIC;
            iRST_N          :   IN STD_LOGIC;
            iVIDEO_ON       :   IN STD_LOGIC;
            iCLK_enable     :   IN STD_LOGIC;
            
            --outputs
            oFrame_Active	:	OUT STD_LOGIC;
			oActive_Y_Cnt   :   OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            oVsync_n        :   OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl of vertical_timer is

---------ENUMERATED TYPES--------------------------------------------------
TYPE STATE_TYPE IS (IDLE, V_SYNC, V_FRONT_PORCH, V_BACK_PORCH, V_ACTIVE);

--------SIGNALS------------------------------------------------------------
SIGNAL state        : STATE_TYPE;
SIGNAL vsync_n      : std_logic;
SIGNAL frame_active : std_logic;
SIGNAL active_Y_Cnt : unsigned(11 downto 0);
SIGNAL vert_timer   : integer range 0 to 4095;

BEGIN

Register_outputs : PROCESS (iCLK) 
begin 
    if (rising_edge(iCLK)) then
        oframe_Active <= frame_active;
        oVsync_n <= Vsync_n;
        oActive_Y_Cnt<= std_logic_vector(active_Y_cnt);
    end if;
end process;

ver_Timer_State_Diagram_Single_Process: process (iCLK,iRST_n) --sensitive only to clock and reset
begin
	if (iRST_n = '0') then
		state <= idle;
		vert_timer <= 0;
		active_Y_cnt <= x"000";
		vsync_n <= '1';
		frame_active <='0';
        --implement state diagram
	elsif (rising_edge(iCLK)) then
		if (iCLK_ENABLE ='1') then
		--default signal assignments at PCLK frequency
		state <= idle;
		vert_timer <= 0;
		active_Y_cnt <= x"000";
		vsync_n <= '1';
		frame_active <='0';
		case state is
			when idle =>
				if (iVIDEO_ON='1') then 
					state <= v_sync;
					vert_timer <= c_Vsync_Pulse_Width - 1;
					vsync_n <= '0'; 	--assert hsync_n active low
					--line_enable <= '1';
				else 
					state <= idle; 
				end if;
			when v_sync =>
				if (vert_timer > 0) then 
					vert_timer <= vert_timer - 1;
					vsync_n <= '0';
					state <= v_sync;
				else 
					vert_timer <= c_Vsync_Back_Porch -1;
					state <= v_back_porch;
                    vsync_n <= '1';
				end if;
			when v_back_porch =>
				if (vert_timer > 0) then 
					vert_timer <= vert_timer - 1;
					state <= v_back_porch;
				else 
					vert_timer <= c_Active_Lines_Frame -1;
					active_Y_Cnt <= active_Y_Cnt + 1;
                    state <= v_active;
                    frame_active <= '1';
				end if;
			when v_active =>
				if (vert_timer > 0) then 
					vert_timer <= vert_timer - 1;
					state <= v_active;
                    active_Y_Cnt <= active_Y_Cnt + 1;
                    frame_active <= '1';
				else 
					vert_timer <= c_Vsync_Front_Porch -1;
					state <= v_front_porch;
                    vsync_n <= '1';
				end if;
			when v_front_porch =>
				if (vert_timer > 0) then 
					vert_timer <= vert_timer -1;
					state <= v_front_porch;
				else 
					state <= v_sync;
					vsync_n <= '0';
					vert_timer <= c_Vsync_Pulse_Width - 1;
				end if;
			when others =>
				state <= idle; --redundant because of default assignments but not harmful
			end case;
		end if;	--end of clock enable block
	end if;	--end of clock block
end process ;
		
		
		
		
END rtl;
