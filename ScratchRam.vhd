library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ScratchRam is
    Port ( SCR_ADDR : in     STD_LOGIC_VECTOR (7 downto 0);
	       SCR_OE   : in     STD_LOGIC;
           SCR_WR   : in     STD_LOGIC;
           CLK      : in     STD_LOGIC;
           SCR_DATA : inout  STD_LOGIC_VECTOR(9 downto 0)
        );
end ScratchRam;

architecture Behavioral of ScratchRam is
	TYPE memory is array (0 to 255) of std_logic_vector(9 downto 0);
	SIGNAL REG: memory := (others=>(others=>'0'));
begin

	process(clk, SCR_DATA,SCR_WR)
	begin
		if (rising_edge(clk)) then
	          if (SCR_WR = '1') then
			REG(conv_integer(SCR_ADDR)) <= SCR_DATA;
		  end if;
		end if;
	end process;

	SCR_DATA <= REG(conv_integer(SCR_ADDR)) when SCR_OE ='1' else (others=>'Z');
	
end Behavioral;