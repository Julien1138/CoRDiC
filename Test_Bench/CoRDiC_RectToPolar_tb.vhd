----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_RectToPolar_tb
--
-- Description:      
--
-- 
-- Create Date:    05/12/2010
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library CoRDiC_Lib;
use CoRDiC_Lib.CoRDiC_Pack.all;

entity CoRDiC_RectToPolar_tb is
end CoRDiC_RectToPolar_tb;

architecture CoRDiC_RectToPolar_tb_Behavior of CoRDiC_RectToPolar_tb is
   
   signal s_clk   : std_logic := '1';
   signal s_rst   : std_logic := '1';
   
   signal s_Start : std_logic := '0';
   signal s_Done  : std_logic;
      
   signal s_X           : std_logic_vector(31 downto 0);
   signal s_Y           : std_logic_vector(31 downto 0);
   
   signal s_Magnitude   : std_logic_vector(31 downto 0);
   signal s_Angle       : std_logic_vector(15 downto 0);
   
   constant c_ClkPeriod : time := 20 ns;   -- 50 MHz
   
begin
   
   s_rst <= '0' after 35 ns;
   s_clk <= not s_clk after c_ClkPeriod/2;
   
   process
   begin
      wait for 100 ns;
      s_Start <= '1';
      s_X <= X"FFFF8000";
      s_Y <= X"00008000";
      wait for c_ClkPeriod;
      s_Start <= '0';
      wait;
   end process;
   
   uut : CoRDiC_RectToPolar
   port map
   (
      clk_i       => s_clk,
      rst_i       => s_rst,
      
      Start_i     => s_Start,
      Done_o      => s_Done,
      
      X_i         => s_X,
      Y_i         => s_Y,
      
      Magnitude_o => s_Magnitude,
      Angle_o     => s_Angle
   );
   
end CoRDiC_RectToPolar_tb_Behavior;
