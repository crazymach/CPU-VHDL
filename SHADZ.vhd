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

entity ShadowZ is
    Port ( SHAD_Z_LD : in STD_LOGIC;
           Z_FLAG : in STD_LOGIC;
           SHAD_Z_OUT : out STD_LOGIC);
end ShadowZ;

architecture Behavioral of ShadowZ is

begin

    shadowZ_LD: process(SHAD_Z_LD, Z_FLAG)
        begin
        if SHAD_Z_LD = '1'
            then SHAD_Z_OUT <= Z_FLAG;
        else
            SHAD_Z_OUT <= '1';
        end if;
   end process;

end Behavioral;
