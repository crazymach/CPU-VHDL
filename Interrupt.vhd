----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2016 04:15:56 PM
-- Design Name: 
-- Module Name: Interrupt - Behavioral
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

entity Interrupt is
    Port ( I_SET : in STD_LOGIC;
           I_CLR : in STD_LOGIC;
           I_FLAG : out STD_LOGIC);
end Interrupt;

architecture Behavioral of Interrupt is

begin
    interrupt: process ( I_SET, I_CLR)
        begin
        if(I_SET = '1')
            then I_FLAG <= '1';
        elsif(I_CLR = '1')
            then I_FLAG <= '0';
        else
             I_FLAG <= '0';
        end if;
    end process;
    

end Behavioral;
