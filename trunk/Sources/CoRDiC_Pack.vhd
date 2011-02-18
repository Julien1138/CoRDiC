----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC_Pack
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

package CoRDiC_Pack is
   
   type t_CordicState is (Idle, Computing);
   type t_CordicMode  is (Rotation, Vector);
   
   component CoRDiC_PolarToRect
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
   end component;
   
   component CoRDiC_KFactorCorrection
      port
      (
         Biased_i    : in std_logic_vector;  --! Biased CoRDiC value
         
         Corrected_o : out std_logic_vector  --! Corrected value
      );
   end component;
   
   component CoRDiC
      generic
      (
         g_Mode   : t_CordicMode
      );
      port
      (
         clk_i    : in std_logic;         --! Global Clock
         rst_i    : in std_logic;         --! Global Reset
         
         Start_i  : in std_logic;         --! Starts the process
         Done_o   : out std_logic;        --! '1' when process is finished
         
         X_i      : in std_logic_vector;  --! Condition de départ sur X
         Y_i      : in std_logic_vector;  --! Condition de départ sur Y
         Z_i      : in std_logic_vector;  --! Condition de départ sur Z
         
         X_o      : out std_logic_vector; --! Valeur de sortie sur X
         Y_o      : out std_logic_vector; --! Valeur de sortie sur Y
         Z_o      : out std_logic_vector  --! Valeur de sortie sur Z
      );
   end component;
   
   component CoRDiC_Atan
      port
      (
         Addr_i   : in std_logic_vector;  --! 
         
         Atan_o   : out std_logic_vector  --! 
      );
   end component;
   
   component CoRDiC_ShiftN
      port
      (
         N_i      : in std_logic_vector;  --! 
         
         Bus_i    : in std_logic_vector;  --! 
         Bus_o    : out std_logic_vector  --! 
      );
   end component;
   
end CoRDiC_Pack;
