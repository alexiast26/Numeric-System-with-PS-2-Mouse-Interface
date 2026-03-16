library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Proiect is
    Port ( CLK: in STD_LOGIC;
           MOUSE_DATA : inout STD_LOGIC;   
           MOUSE_CLK: inout STD_LOGIC;
           RESET : in STD_LOGIC;                                       --buton
           REVERSE : in STD_LOGIC;                                     --switch           
           CA: out STD_LOGIC_VECTOR(7 downto 0);     
           AN: out STD_LOGIC_VECTOR(7 downto 0);                       
           LED_IS_LEFT: out STD_LOGIC);
end Proiect;

architecture Behavioral of Proiect is


component mouse_led 
	port(
		clk, reset: in std_logic;
		ps2d, ps2c: inout std_logic;
		led: out std_logic_vector(1 downto 0)
	);
end component;

component MPG
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component Convertor_decimal
    Port ( Number : in STD_LOGIC_VECTOR(7 downto 0);
           DEC : out STD_LOGIC_VECTOR(7 downto 0));
end component;


component SSD 
    Port ( CLK : in STD_LOGIC;
           NUMBER: in STD_LOGIC_VECTOR(7 downto 0);
           AN : out STD_LOGIC_VECTOR(7 downto 0);
           CA : out STD_LOGIC_VECTOR(7 downto 0));
end component;


signal click: std_logic_vector(1 downto 0);
signal is_led_active: std_logic := '0';
signal count: std_logic_vector(7 downto 0) := (others => '0');                               --numara click-urile
signal resetF: std_logic := '0';
signal DEC: std_logic_vector(7 downto 0);
signal clk_out: std_logic;
signal left, right: std_logic;

begin
BUTTON: MPG port map (btn => RESET, clk => CLK, en => resetF);

--citim informatia din mouse

MOUSE_READ: mouse_led port map(clk=>CLK, reset => resetf, ps2d => MOUSE_DATA, ps2c => MOUSE_CLK, led => click);

--click dreapta click(1)  
--click stanga click(0)  

BL: MPG port map (btn => click(0), clk => CLK, en => left);
BR: MPG port map (btn => click(1), clk => CLK, en => right);

    
COUNTING: process(CLK, REVERSE, resetF)
begin
    if resetF = '1' then
        count <= (others => '0');
    end if;
    if REVERSE = '1' then
        is_led_active <= '0';
    else
        is_led_active <= '1';
    end if;
    
    if rising_edge(CLK) then
        if is_led_active = '1' then                               --daca reverse nu e activ
            if left = '1' then                     
               if(count = 99) then 
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            elsif (count > 0 and right = '1') then      
                count <= count - 1;
            elsif (count = 0 and right = '1') then
                count <= "01100011";
            end if;
            LED_IS_LEFT <= '1';
        elsif is_led_active = '0' then                            --daca reverse e activ
            if right = '1' then
                if(count = 99) then 
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            elsif (count > 0 and left = '1') then
                count <= count - 1;
            elsif (count = 0 and left = '1') then
                count <= "01100011";
            end if;
            LED_IS_LEFT <= '0';
        end if;
    end if;
end process;

CONVERTOR: Convertor_decimal port map(Number => count, DEC => DEC);

SSD_COMP: SSD port map (CLK => CLK, NUMBER =>DEC, AN => AN, CA => CA);

end Behavioral;
