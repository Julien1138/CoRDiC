----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_tb
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

entity CoRDiC_tb is
end CoRDiC_tb;

architecture CoRDiC_tb_Behavior of CoRDiC_tb is
   
   signal s_clk   : std_logic := '1';
   signal s_rst   : std_logic := '1';
   
   signal s_Start : std_logic := '0';
   signal s_Done  : std_logic;
   
   signal s_iX    : std_logic_vector(31 downto 0);
   signal s_iY    : std_logic_vector(31 downto 0);
   signal s_iZ    : std_logic_vector(15 downto 0);
   
   signal s_oX    : std_logic_vector(31 downto 0);
   signal s_oY    : std_logic_vector(31 downto 0);
   signal s_oZ    : std_logic_vector(15 downto 0);
   
   constant c_ClkPeriod : time := 20 ns;   -- 50 MHz
   
begin
   
   s_rst <= '0' after 35 ns;
   s_clk <= not s_clk after c_ClkPeriod/2;
   
   process
   begin
      wait for 100 ns;
      s_Start <= '1';
      s_iX <= X"00008000";
      s_iY <= X"00000000";
      s_iZ <= X"2000";
      wait for c_ClkPeriod;
      s_Start <= '0';
      wait;
   end process;
   
   uut : CoRDiC
   generic map
   (
      g_Mode   => Rotation -- Vector
   )
   port map
   (
      clk_i    => s_clk,
      rst_i    => s_rst,
      
      Start_i  => s_Start,
      Done_o   => s_Done,
      
      X_i      => s_iX,
      Y_i      => s_iY,
      Z_i      => s_iZ,
      
      X_o      => s_oX,
      Y_o      => s_oY,
      Z_o      => s_oZ
   );
   
end CoRDiC_tb_Behavior;
