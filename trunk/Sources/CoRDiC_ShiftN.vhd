----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_ShiftN
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

entity CoRDiC_ShiftN is
   port
   (
      N_i      : in std_logic_vector;  --! 
      
      Bus_i    : in std_logic_vector;  --! 
      Bus_o    : out std_logic_vector  --! 
   );
end CoRDiC_ShiftN;

architecture CoRDiC_ShiftN_Behavior of CoRDiC_ShiftN is
   
   type std_logic_vector_array is array (0 to Bus_i'high) of std_logic_vector(Bus_o'range);
   
   signal s_ShiftArray : std_logic_vector_array;
   
begin
   
   -- TODO : Assert sur les entrées
   -- 2**N_i'length = Bus_i'length
   -- Bus_i'length <= Bus_o'length
   
   ShiftArray_Generate :
   for v_Idx1 in 0 to Bus_i'high generate
   begin
   
      Shift_Generate :
      for v_Idx2 in 0 to Bus_o'high generate
         
         If_1 :
         if v_Idx2 < v_Idx1 generate
            s_ShiftArray(v_Idx1)(Bus_o'high - v_Idx2) <= Bus_i(Bus_i'high);
         end generate;
         If_2 :
         if v_Idx2 >= v_Idx1 and Bus_i'high >= v_Idx2 - v_Idx1 generate
            s_ShiftArray(v_Idx1)(Bus_o'high - v_Idx2) <= Bus_i(Bus_i'high - v_Idx2 + v_Idx1);
         end generate;
         If_3 :
         if v_Idx2 >= v_Idx1 and Bus_i'high < v_Idx2 - v_Idx1 generate
            s_ShiftArray(v_Idx1)(Bus_o'high - v_Idx2) <= '0';
         end generate;
      end generate;
      
   end generate;
   
   Bus_o <= s_ShiftArray(to_integer(unsigned(N_i)));
   
end CoRDiC_ShiftN_Behavior;
