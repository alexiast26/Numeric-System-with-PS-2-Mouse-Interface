library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_8x1 is
    Port ( Sel : integer range 0 to 7;
           D0, D1, D2, D3, D4, D5, D6, D7: in STD_LOGIC_VECTOR(7 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0));
end MUX_8x1;

architecture Behavioral of MUX_8x1 is

begin
with sel select
    Q<=D0 when 0,
       D1 when 1,
       D2 when 2,
       D3 when 3,
       D4 when 4,
       D5 when 5,
       D6 when 6,
       D7 when 7,
       x"FF" when others;
end Behavioral;
