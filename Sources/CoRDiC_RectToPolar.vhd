----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC
--
-- Description:   Rect to Polar mode
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

entity CoRDiC_RectToPolar is
   port
   (
      clk_i       : in std_logic;         --! Global Clock
      rst_i       : in std_logic;         --! Global Reset
      
      Start_i     : in std_logic;         --! Starts the process
      Done_o      : out std_logic;        --! '1' when process is finished
      
      X_i         : in std_logic_vector;  --! X value
      Y_i         : in std_logic_vector;  --! Y value
      
      Magnitude_o : out std_logic_vector; --! Magnitude
      Angle_o     : out std_logic_vector  --! Angle
   );
end CoRDiC_RectToPolar;

architecture CoRDiC_RectToPolar_Behavior of CoRDiC_RectToPolar is
   
   signal s_Start : std_logic;
   
   signal s_RescaledX      : std_logic_vector(X_i'range);
   signal s_RescaledY      : std_logic_vector(Y_i'range);
   signal s_CordicZInput   : std_logic_vector(Angle_o'high downto 0) := (others => '0');   -- Dummy
   
   signal s_CordicDone  : std_logic;
   
   signal s_CordicX  : std_logic_vector(Magnitude_o'range);
   signal s_CordicY  : std_logic_vector(Y_i'high downto 0);  -- Dummy
   signal s_CordicZ  : std_logic_vector(Angle_o'range);
   
   signal s_RescaledMagnitude : std_logic_vector(Magnitude_o'range);
   
   signal s_NegateResult   : std_logic;   -- indique que le resultat doit être décalé de 180°
   
begin
   
   -- TODO : Assert sur les vecteurs d'entrée-sortie
   
   --
   --! PreCoRDiC_process : Pré-traitement pour déplacer l'angle dans la moitié droite du cercle trigonométrique
   --
   PreCoRDiC_process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_Start <= '0';
         s_NegateResult <= '0';
         s_RescaledX <= (others => '0');
         s_RescaledY <= (others => '0');
      elsif rising_edge(clk_i) then
         s_Start <= '0';
         
         if Start_i = '1' then
            s_Start <= '1';
            
            if X_i(X_i'high) = '0' then   -- Si X est positif
               s_RescaledX <= X_i;
               s_RescaledY <= Y_i;
               s_NegateResult <= '0';
            else
               s_RescaledX <= -X_i;
               s_RescaledY <= -Y_i;
               s_NegateResult <= '1';
            end if;
            
         end if;
         
      end if;
   end process;
   
   --
   --! PostCoRDiC_process : Correction du facteur K
   --
   PostCoRDiC_process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         Done_o <= '0';
         Magnitude_o <= std_logic_vector(to_unsigned(0, Magnitude_o'Length));
         Angle_o <= std_logic_vector(to_unsigned(0, Angle_o'Length));
      elsif rising_edge(clk_i) then
         Done_o <= '0';
         
         if s_CordicDone = '1' then
            Done_o <= '1';
            Magnitude_o <= s_RescaledMagnitude;
            
            if s_NegateResult = '1' then
               Angle_o <= not s_CordicZ(s_CordicZ'high) & s_CordicZ(s_CordicZ'high - 1 downto 0);
            else
               Angle_o <= s_CordicZ;
            end if;
            
         end if;
         
      end if;
   end process;
   
   
   ins_CoRDiC : CoRDiC
   generic map
   (
      g_Mode   => Vector
   )
   port map
   (
      clk_i    => clk_i,
      rst_i    => rst_i,
      Start_i  => s_Start,
      Done_o   => s_CordicDone,
      X_i      => s_RescaledX,
      Y_i      => s_RescaledY,
      Z_i      => s_CordicZInput,
      X_o      => s_CordicX,
      Y_o      => s_CordicY,
      Z_o      => s_CordicZ
   );
   
   ins_MagnitudeCorrection : CoRDiC_KFactorCorrection
   port map
   (
      Biased_i    => s_CordicX,
      
      Corrected_o => s_RescaledMagnitude
   );
   
end CoRDiC_RectToPolar_Behavior;
