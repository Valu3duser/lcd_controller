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
--Description: Package containing definitions for LCD timing parameters.  
--
--CHANGELOG:
--2/25/20   : Created

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE LCD_Video_Timing_Parameters_PKG IS
--============================================================================
-- Constant declarations that define horizontal timing
--============================================================================
--LCD Timing Parameters
CONSTANT    c_Pixel_Clock_Period_ns : INTEGER := 40;
CONSTANT 	c_Active_Pclks_Line		: INTEGER := 800;
--CONSTANT 	c_Active_Pclks_Line		: INTEGER := 8; --Faster for simulation when project isn't working
CONSTANT	c_Hsync_Pulse_Width		: INTEGER := 1;
CONSTANT 	c_Hsync_Back_Porch 		: INTEGER := 88;
CONSTANT 	c_Hsync_Front_Porch 	: INTEGER := 40;

--============================================================================
-- Constant declarations that define vertical timing
--============================================================================
--LCD Timing Parameters
CONSTANT 	c_Active_Lines_Frame	: INTEGER := 480;
--CONSTANT 	c_Active_Lines_Frame	: INTEGER := 4; --faster for simulation when project isn't working
CONSTANT	c_Vsync_Pulse_Width		: INTEGER := 1;
CONSTANT 	c_Vsync_Back_Porch 		: INTEGER := 32;--In units of horizontal lines 
CONSTANT 	c_Vsync_Front_Porch 	: INTEGER := 13;--In units of horizontal lines 

END LCD_Video_Timing_Parameters_PKG;

