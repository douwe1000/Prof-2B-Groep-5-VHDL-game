-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 21.12.2022 11:41:17 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_RS232 is
end tb_RS232;

architecture tb of tb_RS232 is

    component RS232
        port (clockin  : in std_logic;
              data_in  : in std_logic;
              clk      : in std_logic;
              rst      : in std_logic;
              led      : out std_logic_vector (15 downto 0));
    end component;

    signal clockin  : std_logic;
    signal data_in  : std_logic := '0';
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal led      : std_logic_vector (7 downto 0);

    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : RS232
    port map (clockin  => clockin,
              data_in  => data_in,
              clk      => clk,
              rst      => rst,
              led      => led);

    -- Clock generation

 ck : process
    begin
    while now <= 5000 ms loop
    tbclock <= '0';
    wait for 4 ns;
    tbclock <= '1';
    wait for 4 ns;
     tbclock <= '0';
    wait for 4 ns;
     tbclock <= '1';
    wait for 4 ns;
     tbclock <= '0';
    wait for 4 ns;
     tbclock <= '1';
    wait for 4 ns;
      tbclock <= '0';
    wait for 4 ns;
    tbclock <= '1';
    wait for 4 ns;
    tbclock <= '0';
    wait for 4 ns;
    tbclock <= '1';
    wait for 4 ns;
     tbclock <= '0';
    wait for 4 ns;
     tbclock <= '1';
    wait for 4 ns;
     tbclock <= '0';
    wait for 4 ns;
     tbclock <= '1';
    wait for 4 ns;
      tbclock <= '0';
    wait for 4 ns;
      tbclock <= '1';
    wait for 4 ns;
wait for 20 ns;
end loop;
end process;
    -- EDIT: Check that clockin is really your main clock signal
    clockin <= TbClock;

   
data : process
begin
    loop
    data_in <= '1';
    wait for 5 ns;
    data_in <= '0';
    wait for 5 ns;
    data_in <= '1';
    wait for 5 ns;
    data_in <= '0';
    wait for 5 ns;
    data_in <= '1';
    wait for 5 ns;
    data_in <= '0';
    wait for 5 ns;
    data_in <= '1';
    wait for 5 ns;
    data_in <= '0';
    wait for 5 ns;
    data_in <= '1';
    wait for 5 ns;
    data_in <= '0';
    wait for 5 ns;
    end loop;
end process;
end tb;

