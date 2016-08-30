----------------------------------------------------------------------------------
-- Company: CPE 233
-- Engineer: Benjamin Yee
-- -------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CU is
    Port ( CLK           : in   STD_LOGIC;
           C             : in   STD_LOGIC;
           Z             : in   STD_LOGIC;
           INT           : in   STD_LOGIC;
		   RST           : in   STD_LOGIC;
		   OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
		   OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);			  
           PC_LD         : out  STD_LOGIC;
		   PC_INC        : out  STD_LOGIC;
	       PC_RESET      : out  STD_LOGIC;
           PC_OE         : out  STD_LOGIC;			  
           PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           SP_LD         : out  STD_LOGIC;
           SP_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
		   SP_RESET      : out  STD_LOGIC;
           RF_WR         : out  STD_LOGIC;
		   RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
           RF_OE         : out  STD_LOGIC;
           REG_IMMED_SEL : out  STD_LOGIC;
           ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
           SCR_WR        : out  STD_LOGIC;
           SCR_OE        : out  STD_LOGIC;
           SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
           C_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           C_FLAG_LD     : out  STD_LOGIC;
           C_FLAG_SET    : out  STD_LOGIC;
           C_FLAG_CLR    : out  STD_LOGIC;
           SHAD_C_LD     : out  STD_LOGIC;
           Z_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           Z_FLAG_LD     : out  STD_LOGIC;
           Z_FLAG_SET    : out  STD_LOGIC;
           Z_FLAG_CLR    : out  STD_LOGIC;
           SHAD_Z_LD     : out  STD_LOGIC;
           I_FLAG_SET    : out  STD_LOGIC;
           I_FLAG_CLR    : out  STD_LOGIC;
		   IO_OE         : out  STD_LOGIC);

end CU;
architecture Behavioral of CU is

    type state_type is (ST_init, ST_fet, ST_exec);
    signal PS,NS : state_type;
		
	signal sig_OPCODE_7: std_logic_vector (6 downto 0);
	
begin
   -- concatenate the all opcodes into a 7-bit complete opcode for
	-- easy instruction decoding.
   sig_OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;

   sync_p: process (CLK, NS, RST)
	begin
	   if (RST = '1') then
		  PS <= ST_init;
		elsif (rising_edge(CLK)) then 
	      PS <= NS;
		end if;
	end process sync_p;


   comb_p: process (sig_OPCODE_7, PS, NS)
   begin
   
    PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	 
    PC_OE         <= '0'; 	PC_INC     <= '0';		      				
    SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
    RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
    REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";                   
    SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";                           
    C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  
    C_FLAG_CLR    <= '0';   SHAD_C_LD  <= '0';                   
    Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  
    Z_FLAG_CLR    <= '0';   SHAD_Z_LD  <= '0';                   
    I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
    IO_OE         <= '0'; 
    
   case PS is
	
		   -- STATE: the init cycle ------------------------------------
			-- Initialize all control outputs to non-active states and reset the PC and SP to all zeros.
		   when ST_init => 
		      NS <= ST_fet;
			  PC_RESET <= '1';
		      SP_RESET <= '1';
				
         -- STATE: the fetch cycle -----------------------------------
         when ST_fet => 
		      NS <= ST_exec;
              PC_INC <= '1';  		      
		      
         -- STATE: the execute cycle ---------------------------------
		   when ST_exec => 
			   NS <= ST_fet;
			    
				-- Repeat the default block for all variables here, noting that any output values desired to be different
				-- from init values shown below will be assigned in the following case statements for each opcode.
            
                PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	 
                PC_OE         <= '0'; 	PC_INC     <= '0';		      				
                SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
                RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
                REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";                   
                SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";                           
                C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  
                C_FLAG_CLR    <= '0';   SHAD_C_LD  <= '0';                   
                Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  
                Z_FLAG_CLR    <= '0';   SHAD_Z_LD  <= '0';                   
                I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
                IO_OE         <= '0';   
				
				case sig_OPCODE_7 is
				
				    -- ADD REG-REG -------------
				    when "0000100" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
				        RF_OE <= '1';
				        ALU_SEL <= "0000";
				        C_FLAG_LD <= '1';
				        Z_FLAG_LD <= '1';
				        
				        
				    -- ADD REG-IMMED -------
				    when "1010000" |"1010001"|"1010010"|"1010011" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
                        RF_OE <= '1';   
				        ALU_SEL <= "0000";
				        REG_IMMED_SEL <= '1';
				        C_FLAG_LD <= '1';
				        Z_FLAG_LD <= '1';
				    -- ADDC REG-REG --------
				    when "0000101" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
                        RF_OE <= '1';
				        ALU_SEL <= "0001";
				        C_FLAG_LD <= '1';
				        Z_FLAG_LD <='1';
				        
				    -- ADDC REG-IMMED -----
				    when "1010100"|"1010101"|"1010110"|"1010111" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
                        RF_OE <= '1';
				        ALU_SEL <= "0001";
				        REG_IMMED_SEL <= '1';
				        C_FLAG_LD <= '1';
				        Z_FLAG_LD <= '1';
				      -- AND REG_REG
				     when "0000000" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
				        RF_OE <= '1';
				        ALU_SEL <= "0101";
				        Z_FLAG_LD <= '1';
				        --AND REG-IMMED--
				     when "1000000"|"1000001"|"1000010"|"1000011" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
				        RF_OE <= '1';
				        ALU_SEL <= "0101";
				        Z_FLAG_LD <='1';
				        REG_IMMED_SEL <= '1';  
				        
				    -- ASR-----
				    when "0100100" =>
				        RF_WR_SEL <= "00";
				        RF_WR <= '1';
                        RF_OE <= '1';
                        C_FLAG_LD <= '1';
                        Z_FLAG_LD <='1';
				        ALU_SEL <= "1101";
				    -- BRCC ----
				    when "0010101" =>
                        if C ='0' then
                            PC_LD <= '1';
                            PC_MUX_SEL <= "00";
                        else 
                        end if;
                        				        
				    
				    -- BRCS -----
				    when "0010100" =>
				         if C = '1' then
				            PC_LD <= '1';
                            PC_MUX_SEL <= "00";
                         else
                         end if;
				    -- BREQ -----
				    when "0010010" =>
				        if Z = '1' then
                             PC_LD <= '1';
                        else
                             PC_MUX_SEL <= "00";
                        end if;
                     --BRNE -----
				    when "0010011" =>
				        if Z = '0' then
                            PC_LD <= '1';
                        else
                            PC_MUX_SEL <= "00";
                        end if;
                        			    
                    
                    --CALL ----
				    when "0010001" =>
				        PC_MUX_SEL <= "00";
                        SCR_ADDR_SEL <= "11";				        
                        PC_LD <= '1';
				        PC_OE <= '1';
				        SCR_WR <= '1';
				        SP_MUX_SEL <= "10";
				    
				    
				    
                        
				    --CLC ----
				    when "0110000" =>
				        C_FLAG_CLR <= '1';
				        
				    
				    --CMP REG-REG
				    when "0001000" =>
				        RF_OE <= '1';
                        ALU_SEL <= "0100";
                        C_FLAG_LD <= '1';
                        Z_FLAG_LD <= '1';
				    --CMP REG-IMMED ---
				    when "1100000"|"1100001"|"1100010"|"1100011" =>
                        REG_IMMED_SEL <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0100";
                        C_FLAG_LD <= '1';
                        Z_FLAG_LD <= '1';
				    --LD REG-REG---
				    when "0001010" =>
				        SCR_ADDR_SEL <= "00";
				        SCR_OE <= '1';
				        RF_WR_SEL <= "01";
				        RF_WR <= '1';
				        
				        
				    
				    --LD REG-IMMED---
				    when "1110000"|"1110001"|"1110010"|"1110011" =>
				        SCR_ADDR_SEL <= "00";
                        SCR_OE <= '1';
                        RF_WR_SEL <= "01";
				        RF_WR <= '1';
				        
				    
				    --LSL---
				    when "0100000" =>
                         RF_WR <= '1';            				 				    
                         RF_OE <= '1';				 				    
                         ALU_SEL <= "1001";
                         C_FLAG_LD <= '1';	
                         Z_FLAG_LD <= '1';			
				    --LSR ---
				    when "0100001" =>
				          RF_WR <= '1';            				 
                          RF_OE <= '1';                 
                          ALU_SEL <= "1010";
				          C_FLAG_LD <= '1';
				          Z_FLAG_LD <= '1';

				    
				    
				    --OR REG-REG----
				    when "0000001" =>
				          RF_WR <= '1';            				 
                          RF_OE <= '1';
                          RF_WR_SEL <= "00";                 
                          ALU_SEL <= "0110";
                          Z_FLAG_LD <= '1';
                          
				    -- OR REG-IMMED ---
				    when "1000100"|"1000101"|"1000110"|"1000111" =>
				          RF_WR <= '1'; 
				          RF_WR_SEL <= "00";
				          Z_FLAG_LD <= '1';           				 
                          RF_OE <= '1';                 
                          ALU_SEL <= "0110";
                          REG_IMMED_SEL <= '1';
				    
--				    -- POP----
				    when "0100110" =>
				        SCR_ADDR_SEL <= "10";
				        SP_MUX_SEL <= "10";
				        SP_LD <= '1';
				        SCR_OE <= '1';
				        RF_WR_SEL <= "01";
				        RF_WR <= '1';
				        
				    -- PUSH ---
				    when "0100101" =>
				        SCR_ADDR_SEL <= "11";
				        SP_MUX_SEL<= "10";
				        SP_LD <= '1';
				        RF_OE <= '1';
				        SCR_WR <='1';
				        
				        
				    -- RET ---
				    when "0110010" =>
				        PC_MUX_SEL <= "01";
				        SP_MUX_SEL <= "11";
				        SCR_ADDR_SEL <= "10";
				        SCR_OE <= '1';
				        SP_LD <= '1';
				        PC_LD <= '1';
				        
				    
				    -- ROL ---
				    when "0100010" =>
				          RF_WR <= '1';            				 
                          RF_OE <= '1';                 
                          ALU_SEL <= "1011";
                          C_FLAG_LD <= '1';
                          Z_FLAG_LD <= '1';	
                          			    
				    -- ROR -----
				    when "0100011" =>
				          RF_WR <= '1';            				 
                          RF_OE <= '1';                 
                          ALU_SEL <= "1100";
                          C_FLAG_LD <='1';
                          Z_FLAG_LD <='1';				    
				    -- SEC
				    when "0110001" =>
				        C_FLAG_SET <= '1';
				    
				    -- ST REG-REG----
				    when "0001011" =>
				        SCR_ADDR_SEL <= "00";
				        SCR_WR<= '1';
				        RF_OE <= '1';
				    
				    -- ST REG-IMMED --
				    when "1110100"|"1110101"|"1110110"|"1110111" =>
                        SCR_ADDR_SEL <= "00";
                        SCR_WR <= '1';			
                        RF_OE <= '1';
                        REG_IMMED_SEL <= '1';	    
				   
				    -- SUB REG-REG -------
				    when "0000110" =>
				        RF_WR_SEL <= "00";
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0010";
                        C_FLAG_LD <= '1';
                        Z_FLAG_LD <= '1';	
				    -- SUB REG-IMMED ----
				    when "1011000"|"1011001"|"1011010"|"1011011" =>
				        RF_WR_SEL <= "00";
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0010";
                        C_FLAG_LD <= '1';
                        Z_FLAG_LD <= '1';	
                        REG_IMMED_SEL <= '1';	
				    -- SUBC REG-REG
				    when "0000111" =>
				        RF_WR_SEL <= "00";
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0011";
                        C_FLAG_LD <= '1';  
                        Z_FLAG_LD <= '1';	
				    -- SUBC REG-IMMED
				    when "1011100"|"1011101"|"1011110"|"1011111" =>
				        RF_WR_SEL <= "00";
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0011";
                        C_FLAG_LD <= '1';		
                        Z_FLAG_LD <= '1';
				    -- TEST REG-REG
				    when "0000011" =>
				          C_FLAG_CLR <= '1';
                          RF_OE <= '1';                 
                          ALU_SEL <= "1000";   
                          Z_FLAG_LD <='1';
				    
				    -- TEST REG-IMMED---
				    when "1001100" |"1001101"|"1001110"|"1001111" =>
				          Z_FLAG_LD <= '1';
				          RF_WR <= '1';            				 
                          RF_OE <= '1';
                          ALU_SEL <= "1000";
                          REG_IMMED_SEL <= '1'; 				    
                    -- WSP 
				    when "0101000" =>
				        SP_LD <= '1';
				        RF_OE <= '1';
				        SP_MUX_SEL <= "00";
				    
				        
					-- IN -------------------
                    when "1100100" | "1100101" | "1100110" | "1100111" =>   
                        RF_WR <= '1';
                        RF_WR_SEL <= "11";
                                
					-- MOV REG-IMMED --------
                    when "1101100"|"1101101"|"1101110"|"1101111" =>				
                        RF_WR <= '1';
                        RF_WR_SEL <= "00";
                        ALU_SEL <= "1110";
                        REG_IMMED_SEL <= '1';
                        RF_OE <= '1';
					-- MOV REG-REG --------
                     when "0001001" =>                
                        RF_WR <= '1';
                        RF_WR_SEL <= "00";
                        ALU_SEL <= "1110";
                        RF_OE <= '1';
                    -- EXOR ------
                    when "0000010" =>
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0111";
                        Z_FLAG_LD <= '1';
                        
					-- EXOR REG-IMMED ------
                    when "1001000"| "1001001"|"1001010"|"1001011" =>
                        RF_WR <= '1';
                        RF_OE <= '1';
                        ALU_SEL <= "0111";
                        REG_IMMED_SEL <= '1';
                        Z_FLAG_LD <= '1';
                	-- OUT ------                    
                    when "1101000" | "1101001" | "1101010" | "1101011" =>
                        RF_OE <= '1';
                        IO_OE <= '1';
                        
					-- BRN ------                    
                    when "0010000" =>
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                   
               when others =>		
                  -- repeat the default block here to avoid incompletely specified outputs and hence avoid
                  -- the problem of inadvertently created latches within the synthesized system.						
						PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';    PC_INC <= '0';			      				
						SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
						RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
						REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
						SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
						C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
						Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
						I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';    

             end case;
                                        
          when others => 
			   NS <= ST_fet;
			    
            -- repeat the default block here to avoid incompletely specified outputs and hence avoid
            -- the problem of inadvertently created latches within the synthesized system.
				PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';   PC_INC <= '0';		      				
				SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
				RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
				REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
				SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
				C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
				Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
				I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';   
				 
	    end case;
   end process comb_p;
end Behavioral;