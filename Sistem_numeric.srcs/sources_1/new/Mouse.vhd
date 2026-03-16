library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mouse is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        PS2_CLK   : in  STD_LOGIC;
        PS2_DATA  : in  STD_LOGIC;
        left_btn  : out STD_LOGIC;
        right_btn : out STD_LOGIC
    );
end Mouse;

architecture Behavioral of Mouse_Click_Interface is
    signal ps2_clk_sync  : STD_LOGIC_VECTOR(2 downto 0);
    signal ps2_data_sync : STD_LOGIC_VECTOR(2 downto 0);
    signal ps2_clk_fall  : STD_LOGIC;
    signal shift_reg     : STD_LOGIC_VECTOR(10 downto 0);
    signal bit_count     : INTEGER range 0 to 10 := 0;
    signal byte_ready    : STD_LOGIC := '0';
    signal byte0         : STD_LOGIC_VECTOR(7 downto 0);
begin

    -- Synchronize PS2 signals
    process (clk, reset)
    begin
        if reset = '1' then
            ps2_clk_sync  <= (others => '1');
            ps2_data_sync <= (others => '1');
        elsif rising_edge(clk) then
            ps2_clk_sync  <= ps2_clk_sync(1 downto 0) & PS2_CLK;
            ps2_data_sync <= ps2_data_sync(1 downto 0) & PS2_DATA;
        end if;
    end process;

    -- Detect falling edge of PS2_CLK
    ps2_clk_fall <= ps2_clk_sync(2) and not ps2_clk_sync(1);

    -- Shift register to read PS2 data
    process (clk, reset)
    begin
        if reset = '1' then
            shift_reg <= (others => '0');
            bit_count <= 0;
            byte_ready <= '0';
        elsif rising_edge(clk) then
            if ps2_clk_fall = '1' then
                shift_reg <= PS2_DATA & shift_reg(10 downto 1);
                if bit_count = 10 then
                    if shift_reg(0) = '0' and shift_reg(9) = '1' then -- Check start and stop bits
                        byte0 <= shift_reg(8 downto 1);
                        byte_ready <= '1';
                    end if;
                    bit_count <= 0;
                else
                    bit_count <= bit_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Update button states
    process (clk, reset)
    begin
        if reset = '1' then
            left_btn <= '0';
            right_btn <= '0';
        elsif rising_edge(clk) then
            if byte_ready = '1' then
                left_btn <= byte0(0);
                right_btn <= byte0(1);
                byte_ready <= '0';
            end if;
        end if;
    end process;

end Behavioral;
