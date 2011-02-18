----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_Atan_tb
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

entity CoRDiC_Atan_tb is
end CoRDiC_Atan_tb;

architecture CoRDiC_Atan_tb_Behavior of CoRDiC_Atan_tb is
   
   signal s_Addr  : std_logic_vector(3 downto 0) := "0000";
   
   signal s_Atan  : std_logic_vector(15 downto 0);
   
begin
   
   s_Addr <= s_Addr + 1 after 10 ns;
   
   uut : CoRDiC_Atan
   port map
   (
      Addr_i   => s_Addr,
      
      Atan_o   => s_Atan
   );
   
end CoRDiC_Atan_tb_Behavior;
