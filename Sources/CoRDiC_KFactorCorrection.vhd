----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_KFactorCorrection
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

entity CoRDiC_KFactorCorrection is
   port
   (
      Biased_i    : in std_logic_vector;  --! Biased CoRDiC value
      
      Corrected_o : out std_logic_vector  --! Corrected value
   );
end CoRDiC_KFactorCorrection;

architecture CoRDiC_KFactorCorrection_Behavior of CoRDiC_KFactorCorrection is
   
   
   constant c_CorrectionGeneric  : std_logic_vector(63 downto 0)     := X"4DBA76D421AF3D30";
   constant c_Correction         : std_logic_vector(Biased_i'range)  := c_CorrectionGeneric(63 downto 64-Biased_i'Length);
   
   
   signal s_Corrected   : std_logic_vector(Biased_i'High + Biased_i'Length downto 0);
   
begin
   
   s_Corrected <= Biased_i*c_Correction;
   
   Corrected_o <= s_Corrected(s_Corrected'high - 1 downto s_Corrected'high - Corrected_o'Length);
   
end CoRDiC_KFactorCorrection_Behavior;
