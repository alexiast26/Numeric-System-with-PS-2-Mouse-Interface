library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DCD_7SEG is
    Port ( S : in STD_LOGIC_VECTOR(3 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0));
end DCD_7SEG;

architecture Behavioral of DCD_7SEG is

begin
with S select
    Q <= "11000000" when "0000",--0
         "11111001" when "0001",--1
         "10100100" when "0010",--2
         "10110000" when "0011",--3
         "10011001" when "0100",--4
         "10010010" when "0101",--5
         "10000010" when "0110",--6
         "11111000" when "0111",--7
         "10000000" when "1000",--8
         "10010000" when "1001",--9
         "11111111" when others;--OFF
end Behavioral;
