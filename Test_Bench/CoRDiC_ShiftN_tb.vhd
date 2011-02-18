----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_ShiftN_tb
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

entity CoRDiC_ShiftN_tb is
end CoRDiC_ShiftN_tb;

architecture CoRDiC_ShiftN_tb_Behavior of CoRDiC_ShiftN_tb is
   
   signal s_N     : std_logic_vector(3 downto 0) := "0000";
   
   signal s_iBus  : std_logic_vector(15 downto 0) := "0111111111111111";
   signal s_oBus  : std_logic_vector(15 downto 0);
   
begin
   
   s_N <= s_N + 1 after 10 ns;
   
   uut : CoRDiC_ShiftN
   port map
   (
      N_i      => s_N,
      
      Bus_i    => s_iBus,
      Bus_o    => s_oBus
   );
   
end CoRDiC_ShiftN_tb_Behavior;
