----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Benjamin Yee
-- 
-- Create Date: 01/27/2016 04:50:04 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAT_CPU is
  Port ( IN_PORT    : in   std_logic_vector (7 downto 0);
         RST        : in   std_logic;
         INT_IN     : in   std_logic;
         CLK        : in   std_logic;
         OUT_PORT   : out  std_logic_vector (7 downto 0);
         PORT_ID    : out  std_logic_vector (7 downto 0);
         IO_OE      : out  std_logic);                  
end RAT_CPU;

architecture Behavioral of RAT_CPU is

    component CU is
    Port (  CLK           : in   STD_LOGIC;
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
    end component;

    component PC is
    Port (  D_IN     : in  STD_LOGIC_VECTOR (9 downto 0);
            PC_OE    : in  STD_LOGIC;
            PC_LD    : in  STD_LOGIC;
            PC_INC   : in  STD_LOGIC;
            RST      : in  STD_LOGIC;
            CLK      : in  STD_LOGIC;
            PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
            PC_TRI   : out STD_LOGIC_VECTOR (9 downto 0));    
    end component;
        
    component ALU is
    Port (  A       : in   STD_LOGIC_VECTOR (7 downto 0);
            B       : in   STD_LOGIC_VECTOR (7 downto 0);
            C_IN    : in   STD_LOGIC;
            SEL     : in   STD_LOGIC_VECTOR (3 downto 0);
            SUM     : out  STD_LOGIC_VECTOR (7 downto 0);
            C_FLAG  : out  STD_LOGIC;
            Z_FLAG  : out  STD_LOGIC);
    end component;    

    component REG is
    Port (  D_IN   : in   STD_LOGIC_VECTOR (7 downto 0);
            DX_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
            DY_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
            ADRX   : in   STD_LOGIC_VECTOR (4 downto 0);
            ADRY   : in   STD_LOGIC_VECTOR (4 downto 0);
            DX_OE  : in   STD_LOGIC;
            WE     : in   STD_LOGIC;
            CLK    : in   STD_LOGIC);
    end component;
    
    component prog_rom is
    PORT (  ADDRESS     : in  STD_LOGIC_VECTOR (9 downto 0); 
            INSTRUCTION : out STD_LOGIC_VECTOR (17 downto 0); 
            CLK         : in  STD_LOGIC);  
    end component;
    
    component C_FLAG is
    Port (  IN_FLAG  : in  STD_LOGIC; 
            LD       : in  STD_LOGIC;
            SET      : in  STD_LOGIC; 
            CLR      : in  STD_LOGIC; 
            CLK      : in  STD_LOGIC;
            OUT_FLAG : out STD_LOGIC);
    end component;           
           
    component Z_FLAG is
    Port (  IN_FLAG  : in  STD_LOGIC;
            LD       : in  STD_LOGIC;
            SET      : in  STD_LOGIC; 
            CLR      : in  STD_LOGIC;
            CLK      : in  STD_LOGIC; 
            OUT_FLAG : out STD_LOGIC);
    end component;               
    component ScratchRam is
        Port ( SCR_ADDR : in     STD_LOGIC_VECTOR (7 downto 0);
               SCR_DATA : inout  STD_LOGIC_VECTOR(9 downto 0);
               SCR_OE   : in     STD_LOGIC;
               SCR_WR   : in     STD_LOGIC;
               CLK      : in     STD_LOGIC);
    end component ScratchRam;
    
    component Stack_Pointer is
        Port (    SP_LD : in STD_LOGIC;
               SP_RESET : in STD_LOGIC;
                  SP_IN : in STD_LOGIC_VECTOR (7 downto 0);
                    CLK : in STD_LOGIC;
                 SP_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component Stack_Pointer;
    
    component ShadowC is
        Port ( SHAD_C_LD : in STD_LOGIC;
               C_FLAG : in STD_LOGIC;
               SHAD_C_OUT : out STD_LOGIC);
    end component ShadowC;
    
    component ShadowZ is
        Port ( SHAD_Z_LD : in STD_LOGIC;
               Z_FLAG : in STD_LOGIC;
               SHAD_Z_OUT : out STD_LOGIC);
    end component ShadowZ;
    
    component Interrupt is
        Port ( I_SET : in STD_LOGIC;
               I_CLR : in STD_LOGIC;
               I_FLAG : out STD_LOGIC);
    end component Interrupt;
    ------------------------signals------------------------
--PC signals--
signal s_pc_ld, s_pc_inc, s_pc_rst, s_pc_oe    : std_logic;
signal s_pc_d_in, s_pc_count                   : std_logic_vector (9 downto 0); 
signal s_pc_mux_sel                            : std_logic_vector (1 downto 0);

--prog_rom signals--
signal IR : std_logic_vector (17 downto 0);

--REG signals--
signal s_rf_oe, s_rf_wr, s_reg_immed_sel        : std_logic;
signal s_wr_data, s_reg_dy_out                  : std_logic_vector (7 downto 0);
signal s_rf_wr_sel                              : std_logic_vector (1 downto 0);

--FlagReg signals--
signal s_c_out, s_c_flag_ld, s_c_flag_set, s_c_flag_clr, s_c_flag : std_logic;
signal s_z_out, s_z_flag_ld, s_z_flag_set, s_z_flag_clr, s_z_flag : std_logic;
signal s_c_flag_sel, s_z_flag_sel                                 : std_logic_vector (1 downto 0);

--ALU signals--
signal s_alu_sel    : std_logic_vector (3 downto 0);
signal s_sum, s_b   : std_logic_vector (7 downto 0);
signal multi_bus    : std_logic_vector (9 downto 0);
--ScratchPad signals--
signal s_SCR_WR        : std_logic;
signal s_SCR_OE        : std_logic;
signal s_SCR_ADDR_SEL  : std_logic_vector (1 downto 0);
signal s_SCR_ADDR      : std_logic_vector (7 downto 0);
--Stack Pointer signals --
signal s_SP_LD     :std_logic;
signal s_SP_MUX_SEL: std_logic_vector (1 downto 0);
signal s_SP_RESET  : std_logic;
signal s_SP_IN     : std_logic_vector(7 downto 0);
signal s_SP_OUT    : std_logic_vector(7 downto 0);
signal s_mux_out   : std_logic_vector(7 downto 0);

begin

    ControlUnit: CU
    Port Map (  CLK             =>  CLK,
                C               =>  s_c_flag,      
                Z               =>  s_z_flag,
                INT             =>  INT_IN,
                RST             =>  RST,
                OPCODE_HI_5     =>  IR (17 downto 13),
                OPCODE_LO_2     =>  IR (1 downto 0),       
                PC_LD           =>  s_pc_ld,
                PC_INC          =>  s_pc_inc,
                PC_RESET        =>  s_pc_rst,
                PC_OE           =>  s_pc_oe,
                PC_MUX_SEL      =>  s_pc_mux_sel,
                SP_LD           =>  s_SP_LD,
                SP_MUX_SEL      =>  s_SP_MUX_SEL,
                SP_RESET        =>  s_SP_RESET,
                RF_WR           =>  s_rf_wr,
                RF_WR_SEL       =>  s_rf_wr_sel,    
                RF_OE           =>  s_rf_oe,
                REG_IMMED_SEL   =>  s_reg_immed_sel,
                ALU_SEL         =>  s_alu_sel,
                SCR_WR          =>  s_SCR_WR,
                SCR_OE          =>  s_SCR_OE,
                SCR_ADDR_SEL    =>  s_SCR_ADDR_SEL,
                C_FLAG_SEL      =>  s_c_flag_sel,
                C_FLAG_LD       =>  s_c_flag_ld,
                C_FLAG_SET      =>  s_c_flag_set,
                C_FLAG_CLR      =>  s_c_flag_clr,
                SHAD_C_LD       =>  open,
                Z_FLAG_SEL      =>  s_z_flag_sel,
                Z_FLAG_LD       =>  s_z_flag_ld,
                Z_FLAG_SET      =>  s_z_flag_set,
                Z_FLAG_CLR      =>  s_z_flag_clr,
                SHAD_Z_LD       =>  open,
                I_FLAG_SET      =>  open,
                I_FLAG_CLR      =>  open,
                IO_OE           =>  IO_OE);
                            
    ProgramCounter: PC
    Port Map (  D_IN        =>  s_pc_d_in,    
                PC_OE       =>  s_pc_oe,
                PC_LD       =>  s_pc_ld,
                PC_INC      =>  s_pc_inc,
                RST         =>  s_pc_rst,
                CLK         =>  CLK,
                PC_COUNT    =>  s_pc_count,
                PC_TRI      =>  multi_bus);                    

    ProgRom: prog_rom
    Port Map (  ADDRESS     =>  s_pc_count,       
                INSTRUCTION =>  IR,
                CLK         =>  CLK);
    
    RegFile: REG
    Port Map (  D_IN    =>  s_wr_data,
                DX_OUT  =>  multi_bus (7 downto 0),
                DY_OUT  =>  s_reg_dy_out,
                ADRX    =>  IR (12 downto 8),
                ADRY    =>  IR (7 downto 3),
                DX_OE   =>  s_rf_oe,
                WE      =>  s_rf_wr,
                CLK     =>  CLK);
                            
                
    C: C_FLAG
    Port Map (  IN_FLAG     =>  s_c_out,
                LD          =>  s_c_flag_ld,
                SET         =>  s_c_flag_set,
                CLR         =>  s_c_flag_clr,
                CLK         =>  CLK,
                OUT_FLAG    =>  s_c_flag);
                
    Z: Z_FLAG
    Port Map (  IN_FLAG     =>  s_z_out,
                LD          =>  s_z_flag_ld,
                SET         =>  s_z_flag_set,
                CLR         =>  s_z_flag_clr,
                CLK         =>  CLK,
                OUT_FLAG    =>  s_z_flag);

    ArithmeticLogicUnit: ALU
    Port Map (  A       =>  multi_bus (7 downto 0),
                B       =>  s_b,
                C_IN    =>  s_c_flag,
                SEL     =>  s_alu_sel,
                SUM     =>  s_sum,
                C_FLAG  =>  s_c_out,
                Z_FLAG  =>  s_z_out);
    RAM: ScratchRAM
    Port Map ( SCR_ADDR => s_SCR_ADDR,
               SCR_DATA => multi_bus,
               SCR_OE   => s_SCR_OE,
               SCR_WR   => s_SCR_WR,
               CLK      => CLK); 
    SP: Stack_Pointer
    Port Map( SP_LD    => s_SP_LD,
              SP_RESET => s_SP_RESET,
              SP_IN    => s_SP_IN,
              CLK      => CLK,
              SP_OUT   =>  s_SP_OUT);  
    
----------------MUX---------------------------------

    

    
    
    PC_Mux: process(s_pc_mux_sel, IR,multi_bus)
    begin
        if s_pc_mux_sel = "00"
            then s_pc_d_in <= IR (12 downto 3);
        elsif s_pc_mux_sel = "01"
            then s_pc_d_in <= multi_bus;
        else
            s_pc_d_in <= "0000000000";            
        end if;
    end process;
    
    ALU_Mux: process(s_reg_immed_sel, IR, s_reg_dy_out)
    begin
        if s_reg_immed_sel = '0'
            then s_b <= s_reg_dy_out;
        else
            s_b <= IR (7 downto 0);
        end if;
    end process;
    
    REG_Mux: process(s_rf_wr_sel, s_sum, IN_PORT,multi_bus)
    begin
        if s_rf_wr_sel = "00"
            then s_wr_data <= s_sum;
        elsif s_rf_wr_sel = "01"
            then s_wr_data <= multi_bus (7 downto 0);
        elsif s_rf_wr_sel = "11"
            then s_wr_data <= IN_PORT;
        else
             s_wr_data <= "00000000";
        end if;
    end process;
    
    SP_MUX: Process(multi_bus,s_SP_MUX_SEL,s_SP_OUT)
    begin
        if s_SP_MUX_SEL = "00" 
            then s_mux_out <= multi_bus(7 downto 0);
        elsif s_SP_MUX_SEL = "10" 
            then s_mux_out <= s_SP_OUT - 1;
        elsif s_SP_MUX_SEL = "11" 
            then s_mux_out <= s_SP_OUT + 1;
        else
            s_mux_out <= "00000000";
        end if;
     end process;
     
     SCR_MUX: Process(s_SP_OUT, s_SCR_ADDR_SEL, IR,s_reg_dy_out)
     begin
        if s_SCR_ADDR_SEL = "00"
            then s_SCR_ADDR <= s_reg_dy_out;
        elsif s_SCR_ADDR_SEL = "01"
            then s_SCR_ADDR <= IR(7 downto 0);
        elsif s_SCR_ADDR_SEL = "10"
            then s_SCR_ADDR <= s_SP_OUT;
        elsif s_SCR_ADDR_SEL = "11"
            then s_SCR_ADDR <= s_SP_OUT - 1 ;
        else
             s_SCR_ADDR <= "00000000";
        end if;
     end process;
    
    PORT_ID <= IR (7 downto 0);
    OUT_PORT <= multi_bus ( 7 downto 0);

end Behavioral;