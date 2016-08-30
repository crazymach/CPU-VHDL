----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Galen Wu, Ben Yee
-- 
-- Create Date: 01/04/2016 05:27:33 PM
-- Design Name: Program Counter
-- Module Name: PROGRAMCOUNTER - Behavioral
-- Project Name: EXP3
-- Target Devices: 
-- Tool Versions: 
-- Description: This is the source code for the program counter which increases
-- its stored by one whenever PC_INC is high. D_IN is dependeable by the mux which
-- has a select switch from 0 to 2. D_IN is also the value that supplies PC_COUNT
-- the value it increments. 
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
use IEEE.STD_LOGIC_ARITH.ALL;                  
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
Port (     D_IN     : in STD_LOGIC_VECTOR (9 downto 0);
           PC_OE    : in STD_LOGIC;
           PC_LD    : in STD_LOGIC;
           PC_INC   : in STD_LOGIC;
           RST      : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
           PC_TRI   : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

    
architecture Behavioral of PC is

    signal T_D  :  STD_LOGIC_VECTOR(9 downto 0);             --signal for the MUX
    signal T_PC :  STD_LOGIC_VECTOR(9 downto 0);            --signal for the Program Counter
begin

    program_count: process(CLK, D_IN, RST,PC_LD,PC_INC)
    begin   
    
     if RST= '1' then           --Active High asynchronous reset
        T_PC <= "0000000000";       
     elsif (rising_edge(CLK)) then
        if (PC_LD = '1') then  
            T_PC <= D_IN;           -- load signal 
        elsif (PC_INC= '1') then
            T_PC <= T_PC + 1;       --Increment signal by 1
        end if; 
     end if;
     end process program_count;

    PC_TRI <= T_PC when PC_OE = '1' else (others => 'Z');      --Tri State for PC_TRI
 
    PC_COUNT <= T_PC;       --Setting PC_COUNT to the value T_PC holds
   
end Behavioral;