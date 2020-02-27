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
--File Name: pattern_generator.vhd
--Description: module to generate color bars
--
--CHANGELOG:
--2/26/20   : Created
--


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
--USE IEEE.numeric_std.ALL;

ENTITY  pattern_generator	IS
    PORT(
			iCLK			: IN    STD_LOGIC;					    -- 50 Mhz System Clock
			iRST_n			: IN	STD_LOGIC;						-- active low systen reset
			iCLK_ENABLE		: IN	STD_LOGIC; 						-- 25Mhz Clock Enable
			active_x_cnt 	: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);  -- active x counter
			active_y_cnt 	: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);  -- active y counter
			frame_active	: IN	STD_LOGIC;
			line_active		: IN	STD_LOGIC;
		--Video Timing Input Signals from horizontal timer and vertical timer
			iHD				: IN	STD_LOGIC;						-- Horizontal sync in
			iVD				: IN	STD_LOGIC;						-- Vertical sync in	
            iDEN            : IN    STD_LOGIC;
		--Video Timing Signals delayed by one PCLK to account for pattern generator latency
			oHD				: OUT	STD_LOGIC;						-- LCD Horizontal sync 
			oVD				: OUT	STD_LOGIC;						-- LCD Vertical sync 	
			oDEN			: OUT	STD_LOGIC;						-- LCD Data Enable
			--LCD SIDE 24-bit RGB Data
			oLCD_R			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- LCD Red color data 
			oLCD_G			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- LCD Green color data  
			oLCD_B			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- LCD Blue color data  
		--Display User Controls
			iVIDEO_ON		: IN	STD_LOGIC;						--	Video On/Off Switch
			iLine_en		: IN	STD_LOGIC);
END ENTITY pattern_generator;

ARCHITECTURE rtl OF pattern_generator IS
--============================================================================
-- Constant declarations
--============================================================================
CONSTANT cGRAY      :STD_LOGIC_VECTOR(23 downto 0):=x"686868";
CONSTANT cYELLOW    :STD_LOGIC_VECTOR(23 downto 0):=x"BFBF00";
CONSTANT cCYAN      :STD_LOGIC_VECTOR(23 downto 0):=x"00BFBF";
CONSTANT cGREEN     :STD_LOGIC_VECTOR(23 downto 0):=x"00BF00";
CONSTANT cMAGENTA   :STD_LOGIC_VECTOR(23 downto 0):=x"BF00BF";
CONSTANT cRED       :STD_LOGIC_VECTOR(23 downto 0):=x"BF0000";
CONSTANT cBLUE      :STD_LOGIC_VECTOR(23 downto 0):=x"0000BF";

CONSTANT cCOLUMN_0_WIDTH :INTEGER:=114;
CONSTANT cCOLUMN_1_WIDTH :INTEGER:=229;
CONSTANT cCOLUMN_2_WIDTH :INTEGER:=343;
CONSTANT cCOLUMN_3_WIDTH :INTEGER:=457;
CONSTANT cCOLUMN_4_WIDTH :INTEGER:=571;
CONSTANT cCOLUMN_5_WIDTH :INTEGER:=686;
CONSTANT cCOLUMN_6_WIDTH :INTEGER:=800;

--===========================================================================
-- SIGNAL declarations
--===========================================================================
SIGNAL	red_1			:	STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL 	green_1			:	STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL 	blue_1			:	STD_LOGIC_VECTOR( 7 DOWNTO 0);

--Begin RTL Code
BEGIN
--=============================================================================
-- Concurrent Signal Assignments
--============================================================================





-----------Simple RGB color patten generator --------
PATTERN_GENERATOR	:	PROCESS(iCLK, iRST_n)
BEGIN
	if (iRST_n = '0') then
		red_1 <= x"00";
		green_1 <= x"00";
		blue_1 <= x"00";
	elsif( rising_edge(iCLK) ) then
		if (iCLK_ENABLE='1') then
			if(frame_active='1' AND line_active='1') then
                if (to_integer(unsigned(active_x_cnt)) < cCOLUMN_0_WIDTH) then
                    red_1   <=  cGRAY(23 downto 16);
                    green_1 <=  cGRAY(15 downto 8);
                    blue_1  <=  cGRAY(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_1_WIDTH) then
                    red_1   <=  cYELLOW(23 downto 16);
                    green_1 <=  cYELLOW(15 downto 8);
                    blue_1  <=  cYELLOW(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_2_WIDTH) then
                    red_1   <=  cCYAN(23 downto 16);
                    green_1 <=  cCYAN(15 downto 8);
                    blue_1  <=  cCYAN(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_3_WIDTH) then
                    red_1   <=  cGREEN(23 downto 16);
                    green_1 <=  cGREEN(15 downto 8);
                    blue_1  <=  cGREEN(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_4_WIDTH) then
                    red_1   <=  cMAGENTA(23 downto 16);
                    green_1 <=  cMAGENTA(15 downto 8);
                    blue_1  <=  cMAGENTA(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_5_WIDTH) then
                    red_1   <=  cRED(23 downto 16);
                    green_1 <=  cRED(15 downto 8);
                    blue_1  <=  cRED(7 downto 0);
                elsif(to_integer(unsigned(active_x_cnt)) < cCOLUMN_6_WIDTH) then
                    red_1   <=  cBLUE(23 downto 16);
                    green_1 <=  cBLUE(15 downto 8);
                    blue_1  <=  cBLUE(7 downto 0);
                end if;            
            else
                red_1   <= (others => '0');
                green_1 <= (others => '0');
                blue_1  <= (others => '0');
            end if;	
		end if;
	end if;	
END PROCESS PATTERN_GENERATOR;	



SYNC_OUTPUTS:  PROCESS(iCLK, iRST_n)
BEGIN
	if (iRST_n = '0') then
		oHD		<= '0';
		oVD		<= '0';
		oDEN 		<=  '0';
		oLCD_R 	<= X"00";
		oLCD_G 	<= X"00";
		oLCD_B 	<= X"00";
	elsif( rising_edge(iCLK) ) then
		if (iCLK_ENABLE='1') then
			oHD		<= iHD;
			oVD		<= iVD;
			oDEN 	<= iDEN;
			oLCD_R 	<= red_1;
			oLCD_G 	<= green_1;
			oLCD_B 	<= blue_1;
		end if;
	end if;		
END PROCESS SYNC_OUTPUTS;

						
END rtl;











