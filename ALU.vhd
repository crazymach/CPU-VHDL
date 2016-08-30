----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2016 03:39:24 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           SUM : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

    signal out_temp : STD_LOGIC_VECTOR (8 downto 0);
begin

    selector: process( A, B, C_IN, SEL)
        begin
            case SEL is
                when "0000" => out_temp <= ('0' & A) + B;                --ADD
                when "0001" => out_temp <= ('0' & A) + B + C_IN;         --ADDC
                when "0010" => out_temp <= ('0' & A) - B;                --SUB
                when "0011" => out_temp <= ('0' & A) - B - C_IN;         --SUBC
                when "0100" => out_temp <= ('0' & A) - B;                --CMP  
                when "0101" => out_temp <= ('0' & A) and ('0' & B);      --AND
                when "0110" => out_temp <= ('0' & A) or ('0' & B);       --OR
                when "0111" => out_temp <= ('0' & A) xor ('0' & B);      --EXOR
                when "1000" => out_temp <= ('0' & A) and ('0' & B);      --TEST
                when "1001" => out_temp <= A(7) & A(6 downto 0) & C_IN;  --LSL
                when "1010" => out_temp <= A(0) & C_IN & A(7 downto 1);  --LSR
                when "1011" => out_temp <= A(7) & A(6 downto 0) & A(7);  --ROL
                when "1100" => out_temp <= A(0) & A(7 downto 1) & A(0);  --ROR
                when "1101" => out_temp <= A(0) & A(7) & A(7 downto 1) ;  --ASR
                when "1110" => out_temp <= '0' & B;                      --MOV
                when others => out_temp <= "000000000";                  --BLANK
            end case;
        end process;
        
        C_FLAG <= out_temp(8);
        
        Z_FLAG <= '1' when out_temp= "00000000" else
                  '0';
        
        SUM <= out_temp(7 downto 0);
        
end Behavioral; 