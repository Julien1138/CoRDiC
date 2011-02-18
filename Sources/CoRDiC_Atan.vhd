----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_Atan
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

library CoRDiC_Lib;
use CoRDiC_Lib.CoRDiC_Pack.all;

entity CoRDiC_Atan is
   port
   (
      Addr_i   : in std_logic_vector;  --! 
      
      Atan_o   : out std_logic_vector  --! 
   );
end CoRDiC_Atan;

architecture CoRDiC_Atan_Behavior of CoRDiC_Atan is
   
   type std_logic_vector_array is array (0 to 31) of std_logic_vector(31 downto 0);
   
   impure function FillAtan return std_logic_vector_array is
      variable v_Tab : std_logic_vector_array;
   begin
      v_Tab( 0) := X"20000000";
      v_Tab( 1) := X"12E4051D";
      v_Tab( 2) := X"09FB385B";
      v_Tab( 3) := X"051111D4";
      v_Tab( 4) := X"028B0D43";
      v_Tab( 5) := X"0145D7E1";
      v_Tab( 6) := X"00A2F61E";
      v_Tab( 7) := X"00517C55";
      v_Tab( 8) := X"0028BE53";
      v_Tab( 9) := X"00145F2E";
      v_Tab(10) := X"000A2F98";
      v_Tab(11) := X"000517CC";
      v_Tab(12) := X"00028BE6";
      v_Tab(13) := X"000145F3";
      v_Tab(14) := X"0000A2F9";
      v_Tab(15) := X"0000517C";
      v_Tab(16) := X"000028BE";
      v_Tab(17) := X"0000145F";
      v_Tab(18) := X"00000A2F";
      v_Tab(19) := X"00000517";
      v_Tab(20) := X"0000028B";
      v_Tab(21) := X"00000145";
      v_Tab(22) := X"000000A2";
      v_Tab(23) := X"00000051";
      v_Tab(24) := X"00000028";
      v_Tab(25) := X"00000014";
      v_Tab(26) := X"0000000A";
      v_Tab(27) := X"00000005";
      v_Tab(28) := X"00000002";
      v_Tab(29) := X"00000001";
      v_Tab(30) := X"00000000";
      v_Tab(31) := X"00000000";
      return v_Tab;
   end function;
   
   signal s_AtanArray : std_logic_vector_array := FillAtan;
   
begin
   
   -- TODO : Assert sur les bus
   

   
   Atan_o <= s_AtanArray(to_integer(unsigned(Addr_i)))(31 downto 32 - Atan_o'length);
   
end CoRDiC_Atan_Behavior;
