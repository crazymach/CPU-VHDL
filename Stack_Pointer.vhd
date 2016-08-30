----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2016 02:06:58 PM
-- Design Name: 
-- Module Name: Stack_Pointer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stack_Pointer is
    Port (    SP_LD : in STD_LOGIC;
           SP_RESET : in STD_LOGIC;
              SP_IN : in STD_LOGIC_VECTOR (7 downto 0);
                CLK : in STD_LOGIC;
             SP_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end Stack_Pointer;

architecture Behavioral of Stack_Pointer is
signal s_stack_pointer : STD_LOGIC_VECTOR ( 7 downto 0);

begin

    stack_pointer: process( SP_LD, SP_RESET, SP_IN, CLK)
    begin
    if SP_RESET = '1' then
        s_stack_pointer <= "00000000";
    elsif( rising_edge(CLK)) then
        if (SP_LD = '1') then
            s_stack_pointer <= SP_IN;
        end if;
    end if;    
    
    end process;
    
      SP_OUT <= s_stack_pointer;  

end Behavioral;
