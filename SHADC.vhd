----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2016 04:06:31 PM
-- Design Name: 
-- Module Name: SHADZ - Behavioral
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

entity ShadowC is
    Port ( SHAD_C_LD : in STD_LOGIC;
           C_FLAG : in STD_LOGIC;
           SHAD_C_OUT : out STD_LOGIC);
end ShadowC;

architecture Behavioral of ShadowC is

begin
    shadowC_ld: process(SHAD_C_LD, C_FLAG)
    begin
    if SHAD_C_LD = '1'
        then  SHAD_C_OUT <= C_FLAG;
    else
        SHAD_C_OUT <= '0';
    end if;
    end process;

end Behavioral;
