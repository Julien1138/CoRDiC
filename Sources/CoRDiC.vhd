----------------------------------------------------------------------------------
-- Engineer:      Julien Aupart
-- 
-- Module Name:    CoRDiC
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

entity CoRDiC is
   generic
   (
      g_Mode   : t_CordicMode := Rotation
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
end CoRDiC;

architecture CoRDiC_Behavior of CoRDiC is
   
   constant c_Width  : std_logic_vector := std_logic_vector(to_unsigned(Z_i'length, integer(ceil(log2(real(Z_i'length))))));
   
   signal sm_State      : t_CordicState;
   signal s_NextState   : t_CordicState;
   
   signal s_Counter     : std_logic_vector(c_Width'range);
   
   signal s_XRegister   : std_logic_vector(X_i'range);
   signal s_YRegister   : std_logic_vector(Y_i'range);
   signal s_ZRegister   : std_logic_vector(Z_i'range);
   
   signal s_ShiftedX    : std_logic_vector(X_i'range);
   signal s_ShiftedY    : std_logic_vector(Y_i'range);
   signal s_AtanZ       : std_logic_vector(Z_i'range);
   
   signal s_AddSub      : std_logic;
   
   --
   -- function f_AddSub
   --
   function fn_AddSub(DataA_i     : in std_logic_vector;
                      DataB_i     : in std_logic_vector;
                      Add_nSub_i  : in std_logic)
   return std_logic_vector is
   begin
      if (Add_nSub_i = '1') then
         return DataA_i + DataB_i;
      else
         return DataA_i - DataB_i;
      end if;
   end function;
   
begin
   
   -- TODO : Assert que tous les vecteurs X Y Z entrée et sortie ont la même taille
   
   
   --
   -- process : StateMachine_Process
   --! State Machine
   --
   s_NextState <= Idle        when s_Counter = c_Width - 1 else
                  Computing   when Start_i = '1' else
                  sm_State;
   StateMachine_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         sm_State <= Idle;
      elsif rising_edge(clk_i) then
         sm_State <= s_NextState;
      end if;
   end process;
   
   --
   -- process : Counter_Process
   --! Counter
   --
   Counter_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_Counter <= (others => '0');
      elsif rising_edge(clk_i) then
      
         if sm_State = Computing then
            s_Counter <= s_Counter + 1;
         else
            s_Counter <= (others => '0');
         end if;
         
      end if;
   end process;
   
   --
   -- process : Done_Process
   --! Done Pulse generation
   --
   Done_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         Done_o <= '0';
      elsif rising_edge(clk_i) then
         Done_o <= '0';
      
         if sm_State = Computing and s_Counter = c_Width - 2 then
            Done_o <= '1';
         end if;
         
      end if;
   end process;
   
   --
   -- process : XRegister_Process
   --! XRegister management process
   --
   XRegister_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_XRegister <= (others => '0');
      elsif rising_edge(clk_i) then
      
         if Start_i = '1' then
            s_XRegister <= X_i;
         elsif sm_State = Computing then
            s_XRegister <= fn_AddSub(s_XRegister, s_ShiftedY, s_AddSub);
         end if;
         
      end if;
   end process;
   X_o <= s_XRegister;
   
   --
   -- process : YRegister_Process
   --! YRegister management process
   --
   YRegister_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_YRegister <= (others => '0');
      elsif rising_edge(clk_i) then
      
         if Start_i = '1' then
            s_YRegister <= Y_i;
         elsif sm_State = Computing then
            s_YRegister <= fn_AddSub(s_YRegister, s_ShiftedX, not s_AddSub);
         end if;
         
      end if;
   end process;
   Y_o <= s_YRegister;
   
   --
   -- process : ZRegister_Process
   --! ZRegister management process
   --
   ZRegister_Process : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_ZRegister <= (others => '0');
      elsif rising_edge(clk_i) then
      
         if Start_i = '1' then
            s_ZRegister <= Z_i;
         elsif sm_State = Computing then
            s_ZRegister <= fn_AddSub(s_ZRegister, s_AtanZ, s_AddSub);
         end if;
         
      end if;
   end process;
   Z_o <= s_ZRegister;
   
   RotationMode_generate :
   if g_Mode = Rotation generate
      s_AddSub <= s_ZRegister(s_ZRegister'high);
   end generate;
   
   VectorMode_generate :
   if g_Mode = Vector generate
      s_AddSub <= not s_YRegister(s_YRegister'high);
   end generate;
   
   Z_Atan : CoRDiC_Atan
   port map
   (
      Addr_i   => s_Counter,
      
      Atan_o   => s_AtanZ
   );
   
   X_Shift : CoRDiC_ShiftN
   port map
   (
      N_i      => s_Counter,
      
      Bus_i    => s_XRegister,
      Bus_o    => s_ShiftedX
   );
   
   Y_Shift : CoRDiC_ShiftN
   port map
   (
      N_i      => s_Counter,
      
      Bus_i    => s_YRegister,
      Bus_o    => s_ShiftedY
   );
   
end CoRDiC_Behavior;
