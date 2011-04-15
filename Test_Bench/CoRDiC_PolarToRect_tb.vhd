----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_PolarToRect_tb
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

entity CoRDiC_PolarToRect_tb is
end CoRDiC_PolarToRect_tb;

architecture CoRDiC_PolarToRect_tb_Behavior of CoRDiC_PolarToRect_tb is
   
   signal s_clk   : std_logic := '1';
   signal s_rst   : std_logic := '1';
   
   signal s_Start : std_logic := '0';
   signal s_Done  : std_logic;
   
   signal s_Magnitude   : std_logic_vector(31 downto 0);
   signal s_Angle       : std_logic_vector(15 downto 0);
      
   signal s_X           : std_logic_vector(31 downto 0);
   signal s_Y           : std_logic_vector(31 downto 0);
   
   constant c_ClkPeriod : time := 20 ns;   -- 50 MHz
   
begin
   
   s_rst <= '0' after 35 ns;
   s_clk <= not s_clk after c_ClkPeriod/2;
   
   -- process
   -- begin
      -- wait for 100 ns;
      -- s_Start <= '1';
      -- s_Magnitude <= X"00008000";
      -- s_Angle <= X"A000";
      -- wait for c_ClkPeriod;
      -- s_Start <= '0';
      -- wait;
   -- end process;
   
   process(s_rst, s_clk)
   begin
      if s_rst = '1' then
         s_Start <= '1';
         s_Magnitude <= X"00008000";
         s_Angle <= X"A000";
      elsif rising_edge(s_clk) then
         s_Start <= '0';
         
         if s_Done = '1' then
            s_Start <= '1';
            s_Angle <= s_Angle + X"100";
         end if;
         
      end if;
   end process;
   
   uut : CoRDiC_PolarToRect
   port map
   (
      clk_i       => s_clk,
      rst_i       => s_rst,
      
      Start_i     => s_Start,
      Done_o      => s_Done,
      
      Magnitude_i => s_Magnitude,
      Angle_i     => s_Angle,
      
      X_o         => s_X,
      Y_o         => s_Y
   );
   
end CoRDiC_PolarToRect_tb_Behavior;
