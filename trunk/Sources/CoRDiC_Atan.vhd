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
   
   type std_logic_vector_array is array (0 to 63) of std_logic_vector(63 downto 0);
   
   impure function FillAtan return std_logic_vector_array is
      variable v_Tab : std_logic_vector_array;
   begin
      v_Tab( 0) := X"2000000000000000";
      v_Tab( 1) := X"12E4051D9DF30866";   -- 1361218612134873190
      v_Tab( 2) := X"09FB385B5EE39E8D";   -- 719230530580881037*
      v_Tab( 3) := X"051111D41DDD9A1B";   -- 365092647525521947
      v_Tab( 4) := X"028B0D430E589AEC";   -- 183254791493294828*
      v_Tab( 5) := X"0145D7E159046278";   -- 91716730292036216
      v_Tab( 6) := X"00A2F61E5C282629";   -- 45869556482713129*
      v_Tab( 7) := X"00517C5511D442AE";   -- 22936177926750894*
      v_Tab( 8) := X"0028BE5346D0C336";   -- 11468263948075830*
      v_Tab( 9) := X"00145F2EBB30AB37";   -- 5734153847876407*
      v_Tab(10) := X"000A2F980091BA7B";   -- 2867079658191483
      v_Tab(11) := X"000517CC14A80CB7";   -- 1433540170878135
      v_Tab(12) := X"00028BE60CDFEC61";   -- 716770128161889*
      v_Tab(13) := X"000145F306C172F2";   -- 358385069421298
      v_Tab(14) := X"0000A2F9836AE911";   -- 179192535378193
      v_Tab(15) := X"0000517CC1B6BA7C";
      v_Tab(16) := X"000028BE60DB85FC";
      v_Tab(17) := X"0000145F306DC816";
      v_Tab(18) := X"00000A2F9836E4AE";
      v_Tab(19) := X"00000517CC1B726B";
      v_Tab(20) := X"0000028BE60DB938";
      v_Tab(21) := X"00000145F306DC9C";
      v_Tab(22) := X"000000A2F9836E4E";
      v_Tab(23) := X"000000517CC1B727";
      v_Tab(24) := X"00000028BE60DB94";
      v_Tab(25) := X"000000145F306DCA";
      v_Tab(26) := X"0000000A2F9836E5";
      v_Tab(27) := X"0000000517CC1B72";
      v_Tab(28) := X"000000028BE60DB9";
      v_Tab(29) := X"0000000145F306DD";
      v_Tab(30) := X"00000000A2F9836E";
      v_Tab(31) := X"00000000517CC1B7";
      v_Tab(32) := X"0000000028BE60DC";
      v_Tab(33) := X"00000000145F306E";
      v_Tab(34) := X"000000000A2F9837";
      v_Tab(35) := X"000000000517CC1B";
      v_Tab(36) := X"00000000028BE60E";
      v_Tab(37) := X"000000000145F307";
      v_Tab(38) := X"0000000000A2F983";
      v_Tab(39) := X"0000000000517CC2";
      v_Tab(40) := X"000000000028BE61";
      v_Tab(41) := X"0000000000145F30";
      v_Tab(42) := X"00000000000A2F98";
      v_Tab(43) := X"00000000000517CC";
      v_Tab(44) := X"0000000000028BE6";
      v_Tab(45) := X"00000000000145F3";
      v_Tab(46) := X"000000000000A2FA";
      v_Tab(47) := X"000000000000517D";
      v_Tab(48) := X"00000000000028BE";
      v_Tab(49) := X"000000000000145F";
      v_Tab(50) := X"0000000000000A30";
      v_Tab(51) := X"0000000000000518";
      v_Tab(52) := X"000000000000028C";
      v_Tab(53) := X"0000000000000146";
      v_Tab(54) := X"00000000000000A3";
      v_Tab(55) := X"0000000000000051";
      v_Tab(56) := X"0000000000000029";
      v_Tab(57) := X"0000000000000014";
      v_Tab(58) := X"000000000000000A";
      v_Tab(59) := X"0000000000000005";
      v_Tab(60) := X"0000000000000003";
      v_Tab(61) := X"0000000000000001";
      v_Tab(62) := X"0000000000000001";
      v_Tab(63) := X"0000000000000000";
      return v_Tab;
   end function;
   
   signal s_AtanArray : std_logic_vector_array := FillAtan;
   
begin
   
   -- TODO : Assert sur les bus
   

   
   Atan_o <= s_AtanArray(to_integer(unsigned(Addr_i)))(63 downto 64 - Atan_o'length);
   
end CoRDiC_Atan_Behavior;
