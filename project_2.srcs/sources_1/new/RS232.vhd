----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2022 13:36:12
-- Design Name: 
-- Module Name: RS232 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;       --nodig voor bitshift
library work;
use work.vga.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RS232 is
  Port ( clockin    : in std_logic;
         data_in    : in std_logic;
         HSYNC : out std_logic; --output monitor
         VSYNC : out std_logic;
         clk        : in std_logic;
         rst        : in std_logic;
         led        : out std_logic_vector(0 to 15);
         R : out std_logic_vector(3 downto 0);
         G : out std_logic_vector(3 downto 0);
         B : out std_logic_vector(3 downto 0));
end RS232;

architecture Behavioral of RS232 is

    signal data_buf     : unsigned(7 downto 0) := (others => '0'); 
    signal tel          : integer range 0 to 8; 
    signal data32       : std_logic_vector(0 to 31); 
   type t_array is array (0 to 31) of std_logic;
   signal array_mux : t_array;
begin

scherm: VGAdriver port map (
HSYNC => HSYNC, 
VSYNC => VSYNC, 
clk => clk, 
rst => rst, 
R => R, 
G => G, 
B => B,
rsbuf => data32);

rs232:process(clockin)

variable tel32        : integer range 0 to 33;
variable datashifter  : std_logic_vector  (0 to 31);

begin

if  rising_edge(clockin)then
    if (tel32 < 32) then
        datashifter(tel32) := data_in;   
        tel32 := tel32 +1;
        
        if (tel32 > 31) then
            data32 <= datashifter;
            tel32 := 0;
            datashifter := (others => '0'); 
            led <= data32(0 to 15);
        end if; 
    end if; 
end if; 
 
end process;

 

end Behavioral;
