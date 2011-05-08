----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_Synthesis_Wrapper
--
-- Description:      
--
-- 
-- Create Date:    19/07/2009
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library CoRDiC_Lib;
use CoRDiC_Lib.CoRDiC_Pack.all;

entity CoRDiC_Synthesis_Wrapper is
   generic
   (
      g_Mode   : t_CordicMode := Rotation
   );
   port
   (
      clk_i    : in std_logic;         --! Global Clock
      rst_i    : in std_logic;         --! Global Reset
      
      Start_i  : in std_logic;         --! Démarre le calcul
      Done_o   : out std_logic;        --! Indique que le calcul est terminée
      
      X_i      : in std_logic_vector(31 downto 0);    --! Condition de départ sur X
      Y_i      : in std_logic_vector(31 downto 0);    --! Condition de départ sur Y
      Z_i      : in std_logic_vector(15 downto 0);    --! Condition de départ sur Z
      
      X_o      : out std_logic_vector(31 downto 0);   --! Valeur de sortie sur X
      Y_o      : out std_logic_vector(31 downto 0);   --! Valeur de sortie sur Y
      Z_o      : out std_logic_vector(15 downto 0)    --! Valeur de sortie sur Z
   );
end CoRDiC_Synthesis_Wrapper;

architecture CoRDiC_Synthesis_Wrapper_Behavior of CoRDiC_Synthesis_Wrapper is
   
begin
   
   CoRDiC_Synthesis : CoRDiC
   generic map
   (
      g_Mode => Rotation
   )
   port map
   (
      clk_i    => clk_i,
      rst_i    => rst_i,
      
      Start_i  => Start_i,
      Done_o   => Done_o,
      
      X_i      => X_i,
      Y_i      => Y_i,
      Z_i      => Z_i,
      
      X_o      => X_o,
      Y_o      => Y_o,
      Z_o      => Z_o
   );
   
end CoRDiC_Synthesis_Wrapper_Behavior;
