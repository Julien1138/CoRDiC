----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC
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
use ieee.math_real.all;

library CoRDiC_Lib;
use CoRDiC_Lib.CoRDiC_Pack.all;

entity CoRDiC_PolarToRect is
   port
   (
      clk_i       : in std_logic;         --! Global Clock
      rst_i       : in std_logic;         --! Global Reset
      
      Start_i     : in std_logic;         --! Starts the process
      Done_o      : out std_logic;        --! '1' when process is finished
      
      Magnitude_i : in std_logic_vector;  --! Magnitude
      Angle_i     : in std_logic_vector;  --! Angle
      
      X_o         : out std_logic_vector; --! X value
      Y_o         : out std_logic_vector  --! Y value
   );
end CoRDiC_PolarToRect;

architecture CoRDiC_PolarToRect_Behavior of CoRDiC_PolarToRect is
   
   signal s_Start : std_logic;
   
   signal s_RescaledMagnitude : std_logic_vector(Magnitude_i'range);
   signal s_CordicYInput      : std_logic_vector(Magnitude_i'range) := (others => '0');   -- Dummy
   signal s_RescaledAngle     : std_logic_vector(Angle_i'high downto 0);
   
   signal s_CordicDone  : std_logic;
   
   signal s_CordicX  : std_logic_vector(X_o'range);
   signal s_CordicY  : std_logic_vector(Y_o'range);
   signal s_CordicZ  : std_logic_vector(Angle_i'high downto 0);  -- Dummy
   
   signal s_RescaledX   : std_logic_vector(X_o'range);
   signal s_RescaledY   : std_logic_vector(Y_o'range);
   
begin
   
   -- TODO : Assert sur les vecteurs d'entrée-sortie
   
   PreCoRDiC_process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_Start <= '0';
         s_RescaledAngle <= (others => '0');
         s_RescaledMagnitude <= (others => '0');
      elsif rising_edge(clk_i) then
         s_Start <= '0';
         
         if Start_i = '1' then
            s_Start <= '1';
            s_RescaledAngle <= Angle_i(Angle_i'high - 1) & Angle_i(Angle_i'high - 1 downto 0);
            
            if Angle_i(Angle_i'high) /= Angle_i(Angle_i'high - 1) then
               s_RescaledMagnitude <= -Magnitude_i;
            else
               s_RescaledMagnitude <= Magnitude_i;
            end if;
         end if;
         
      end if;
   end process;
   
   PostCoRDiC_process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         Done_o <= '0';
         X_o <= std_logic_vector(to_unsigned(0, X_o'Length));
         Y_o <= std_logic_vector(to_unsigned(0, Y_o'Length));
      elsif rising_edge(clk_i) then
         Done_o <= '0';
         
         if s_CordicDone = '1' then
            Done_o <= '1';
            X_o <= s_RescaledX;
            Y_o <= s_RescaledY;
         end if;
         
      end if;
   end process;
   
   
   ins_CoRDiC : CoRDiC
   generic map
   (
      g_Mode   => Rotation
   )
   port map
   (
      clk_i    => clk_i,
      rst_i    => rst_i,
      Start_i  => s_Start,
      Done_o   => s_CordicDone,
      X_i      => s_RescaledMagnitude,
      Y_i      => s_CordicYInput,
      Z_i      => s_RescaledAngle,
      X_o      => s_CordicX,
      Y_o      => s_CordicY,
      Z_o      => s_CordicZ
   );
   
   ins_XCorrection : CoRDiC_KFactorCorrection
   port map
   (
      Biased_i    => s_CordicX,
      
      Corrected_o => s_RescaledX
   );
   
   ins_YCorrection : CoRDiC_KFactorCorrection
   port map
   (
      Biased_i    => s_CordicY,
      
      Corrected_o => s_RescaledY
   );
   
end CoRDiC_PolarToRect_Behavior;
