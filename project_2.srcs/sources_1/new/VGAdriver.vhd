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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAdriver is
  Port ( 
         rsbuf : in std_logic_vector(0 to 31); 
         HSYNC : out std_logic; --output monitor
         VSYNC : out std_logic;
         clk        : in std_logic;
         rst        : in std_logic;
         R : out std_logic_vector(3 downto 0);
         G : out std_logic_vector(3 downto 0);
         B : out std_logic_vector(3 downto 0));
end VGAdriver;

architecture Behavioral of VGAdriver is

    signal tel1 : integer range 0 to 3;
    signal klok25 : std_logic := '0';
    signal hPos : integer := 0;
    signal vPos : integer := 0;

    signal videoOn : std_logic := '0';
    signal rsbuf_t : std_logic_vector(0 to 31);

    constant deler : integer := 1;
    constant HD : integer := 639; --horizontaal
    constant HFP : integer := 16; --rechter
    constant HSP : integer := 96; --sync puls
    constant HBP : integer := 48; --linker

    constant VD : integer := 479; --verticale
    constant VFP : integer := 10; --rechter
    constant VSP : integer := 2; --sync pulse
    constant VBP : integer := 33; --linker
    
    
    signal bin1, bin2, bin3, bin4: integer range 0 to 480;
    signal rsbuf_nep : std_logic_vector (0 to 31) := "11111111000000111111000011111111";
begin

clk_div:process(clk, tel1)
begin
    if rising_edge(clk) then
        tel1 <= tel1 + 1;
     if tel1 = deler then
        klok25 <= not klok25;
        tel1 <= 0;
    end if;
end if;
end process;

Horizontaal_pos_tel:process(klok25,rst)
begin
 if (rst = '1')then
     hpos <= 0;
 elsif(klok25'event and klok25 = '1')then
 if(hPos = (HD + HFP + HSP + HBP)) then --als je aan het einde bent van het scherm dan reset
    hPos <= 0;
 else
    hPos <= hPos +1;
 end if;
 end if;
end process;

Verticaal_pos_tel:process(klok25,rst, hPos)
begin
 if (rst = '1')then
    vPos <= 0;
 elsif(klok25'event and klok25 = '1')then
 if(hPos = (HD + HFP + HSP + HBP))then
 if(vPos = (VD + VFP + VSP + VBP)) then --als je aan het einde bent van het scherm dan reset
     vPos <= 0;
 else
    vPos <= vPos +1;
 end if;
 end if;
 end if;
end process;

Horizontaal_sync:process(klok25, rst, hPos)
begin
if (rst = '1')then
 HSYNC <= '0';
 elsif(klok25'event and klok25 = '1')then
 if((hPos <= (HD +HFP))OR (hPos > HD +HFP +HSP)) then
HSYNC <= '1';
 else
HSYNC <= '0';

end if;
end if;
end process;

Verticaal_sync:process(klok25, rst, vPos)
begin
if (rst = '1')then
 VSYNC <= '0';
 elsif(klok25'event and klok25 = '1')then
 if((vPos <= (VD +VFP))OR (vPos >= (VD + VFP + VSP))) then
    VSYNC <= '1';
 else
    VSYNC <= '0';
 end if;
end if;
end process;

vid_on:process(klok25,rst, hPos, vPos)
begin
if (rst = '1')then
    videoOn <= '0';
 elsif(klok25'event and klok25 = '1')then
 if(hPos <= HD and vPos <= VD) then
     videoOn <= '1';
 else
     videoOn <= '0';
 end if;
end if;
end process;


-- voor testen alleen
--bin1 <= 0;
--bin2 <= 50;
--bin3 <= 100;
--bin4 <= 400;

-- testen moet nep rsbuf
--bin1 <= to_integer(unsigned(rsbuf_nep (0 to 7)));
--bin2 <= to_integer(unsigned(rsbuf_nep (8 to 15)));
--bin3 <= to_integer(unsigned(rsbuf_nep (16 to 23)));
--bin4 <= to_integer(unsigned(rsbuf_nep (24 to 31)));

-- voor echte code

rsbuf_t(7) <= rsbuf(0);
rsbuf_t(6) <= rsbuf(1);
rsbuf_t(5) <= rsbuf(2);
rsbuf_t(4) <= rsbuf(3);
rsbuf_t(3) <= rsbuf(4);
rsbuf_t(2) <= rsbuf(5);
rsbuf_t(1) <= rsbuf(6);
rsbuf_t(0) <= rsbuf(7);

rsbuf_t(15) <= rsbuf(8);
rsbuf_t(14) <= rsbuf(9);
rsbuf_t(13) <= rsbuf(10);
rsbuf_t(12) <= rsbuf(11);
rsbuf_t(11) <= rsbuf(12);
rsbuf_t(10) <= rsbuf(13);
rsbuf_t(9) <= rsbuf(14);
rsbuf_t(8) <= rsbuf(15);

rsbuf_t(23) <= rsbuf(16);
rsbuf_t(22) <= rsbuf(17);
rsbuf_t(21) <= rsbuf(18);
rsbuf_t(20) <= rsbuf(19);
rsbuf_t(19) <= rsbuf(20);
rsbuf_t(18) <= rsbuf(21);
rsbuf_t(17) <= rsbuf(22);
rsbuf_t(16) <= rsbuf(23);

rsbuf_t(31) <= rsbuf(24);
rsbuf_t(30) <= rsbuf(25);
rsbuf_t(29) <= rsbuf(26);
rsbuf_t(28) <= rsbuf(27);
rsbuf_t(27) <= rsbuf(28);
rsbuf_t(26) <= rsbuf(29);
rsbuf_t(25) <= rsbuf(30);
rsbuf_t(24) <= rsbuf(31);

bin1 <= to_integer(unsigned(rsbuf_t (0 to 7)));
bin2 <= to_integer(unsigned(rsbuf_t (8 to 15)));
bin3 <= to_integer(unsigned(rsbuf_t (16 to 23)));
bin4 <= to_integer(unsigned(rsbuf_t (24 to 31)));

draw:process(klok25, rst, hPos, vPos, videoOn)
begin
if (rst = '1')then
 R <= "0000";
 G <= "0000";
 B <= "0000";
 elsif(klok25'event and klok25 = '1')then
 if(videoOn <= '1') then
 --code voor beeld:
 --elsif((hpos >= freq and hpos <= freq +4) AND AND (vPos >= VD and vPos <= ampl)then

 R <= "0000"; G <= "1111"; B <= "0000";

     if hPos > 111 and hPos < 139 and vPos > (480-bin1*2)  and  vPos < 480 then -- 480 max voor y-as
       R <= "1111"; G <= "0000"; B <= "0000";
       end if;
       
    if hPos > 241 and hPos < 269 and vPos > (480-bin2*2)  and  vPos < 480 then -- 480 max voor y-as
       R <= "1111"; G <= "0000"; B <= "0000";
       end if;
       
    if hPos > 370 and hPos < 398 and vPos > (480-bin3*2) and  vPos < 480 then -- 480 max voor y-as
       R <= "1111"; G <= "0000"; B <= "0000";
       end if;
       
    if hPos > 500 and hPos < 528 and vPos > (480-bin4*2) and  vPos < 480 then -- 480 max voor y-as
       R <= "1111"; G <= "0000"; B <= "0000";
       end if;
 
end if;
end if;
end process;


end Behavioral;

---------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;       --nodig voor bitshift

package vga is

component VGAdriver is
  Port ( 
         rsbuf : in std_logic_vector(0 to 31); 
         HSYNC : out std_logic; --output monitor
         VSYNC : out std_logic;
         clk        : in std_logic;
         rst        : in std_logic;
         R : out std_logic_vector(3 downto 0);
         G : out std_logic_vector(3 downto 0);
         B : out std_logic_vector(3 downto 0));
end component;

end vga;