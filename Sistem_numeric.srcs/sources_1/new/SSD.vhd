library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SSD is
    Port ( CLK : in STD_LOGIC;
           NUMBER: in STD_LOGIC_VECTOR(7 downto 0);
           AN : out STD_LOGIC_VECTOR(7 downto 0);
           CA : out STD_LOGIC_VECTOR(7 downto 0));
    type Afisare is array(7 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    type Cat_Arr is array(7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
end SSD;

architecture Behavioral of SSD is
signal Afis: Afisare := (x"0", x"0", x"0", x"0", x"0", x"0", x"0", x"0");  --std_logic_vector(7 downto 0) := others => '0'
signal CAT:Cat_ARR := (x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF");
signal count: natural range 0 to 7 := 0;
signal clk_div: STD_LOGIC;

component clock_div is 
    generic (N: integer := 100_000_000);
    port (clk,reset: in std_logic;
          clock_out: out std_logic);
end component;

component DCD_7SEG is
    Port ( S : in STD_LOGIC_VECTOR(3 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component MUX_8x1 is
    Port ( Sel : integer range 0 to 7;
           D0, D1, D2, D3, D4, D5, D6, D7: in STD_LOGIC_VECTOR(7 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0));
end component;

begin
Afis(0) <= NUMBER(3 downto 0);    --cifra unitatilor
Afis(1) <= NUMBER(7 downto 4);    --cifra zecilor

CLOCK: clock_div generic map(108_000) port map(CLK, '0', clk_div);

DCD_7S: for i in 0 to 7 generate
    DCD_COMP: DCD_7SEG port map (Afis(i), CAT(i));
end generate DCD_7S;

CMUX: MUX_8x1 port map(count, CAT(0), CAT(1), CAT(2),CAT(3), CAT(4), CAT(5), CAT(6), CAT(7), CA);
AMUX: MUX_8x1 port map(count, x"FE", x"FD", x"FB", x"F7", x"EF", x"DF", x"BF", x"7F", AN);

process(clk_div)
begin
    if rising_edge(clk_div) then
        count <= count + 1;
    end if;
end process;
end Behavioral;
