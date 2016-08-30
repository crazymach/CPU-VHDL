----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    1/31/2012
-- Design Name: 
-- Module Name:    RAT_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_wrapper is
    Port ( LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
           SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
	       RST      : in    STD_LOGIC;
           CLK      : in    STD_LOGIC);
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is
-- INPUT PORT IDS -------------------------------------------------------------
-- Right now, the only possible inputs are the switches
-- In future labs you can add more port IDs, and you'll have
-- to add constants here for the mux below
CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
-------------------------------------------------------------------------------
-- OUTPUT PORT IDS ------------------------------------------------------------
-- In future labs you can add more port IDs
CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
-------------------------------------------------------------------------------

-- Declare RAT_CPU ------------------------------------------------------------
component RAT_CPU 
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
           RST      : in  STD_LOGIC;
	       IO_OE    : out STD_LOGIC;
           INT_IN   : in  STD_LOGIC;
           CLK      : in  STD_LOGIC);
end component RAT_CPU;

-------------------------------------------------------------------------------

-- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------

signal input_port  : std_logic_vector (7 downto 0);
signal output_port : std_logic_vector (7 downto 0);
signal port_id     : std_logic_vector (7 downto 0);
signal load        : std_logic;
signal interrupt   : std_logic; -- not yet used

-------------------------------------------------------------------------------

begin

-- Instantiate RAT_CPU --------------------------------------------------------

CPU: RAT_CPU
    port map(   IN_PORT  => input_port,
                OUT_PORT => output_port,
	            PORT_ID  => port_id,
                RST      => RST,  
                IO_OE    => load,
                INT_IN   => interrupt,
                CLK      => CLK);
				
-------------------------------------------------------------------------------


-- Mux for selecting what input to read -----------------------------------
INPUTS: process(port_id, SWITCHES)
  begin
    if port_id = SWITCHES_ID then
       input_port <= SWITCHES;
    else
       input_port <= x"00";
    end if;
end process INPUTS;
-------------------------------------------------------------------------------


-- Mux for updating outputs -----------------------------------------------
--Note that outputs are updated on the rising edge of the clock, when
--the load signal is asserted
OUTPUTS: process(CLK) begin
  if (rising_edge(CLK)) then
    if (load = '1' and port_id = LEDS_ID) then
      LEDS <= output_port;
    end if;
  end if;
end process OUTPUTS;
	
-------------------------------------------------------------------------------

end Behavioral;