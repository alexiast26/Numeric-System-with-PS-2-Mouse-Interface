library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mouse_led is
	port(
		clk, reset: in std_logic;
		ps2d, ps2c: inout std_logic;
		led: out std_logic_vector(1 downto 0)
	);
end mouse_led;

architecture behavioral of mouse_led is
	signal p_reg, p_next: unsigned(9 downto 0);
	signal xm: std_logic_vector(8 downto 0);
	signal btnm: std_logic_vector(2 downto 0);
	signal m_done_tick: std_logic;
begin
	mouse_unit: entity work.Mouse_D
		port map(
			clk => clk,
			reset => reset,
			ps2d => ps2d,
			ps2c => ps2c,
			xm => xm,
			ym => open,
			btnm => btnm,
			m_done_tick => m_done_tick
		);

led(0) <= btnm(0);
led(1) <= btnm(1);
end behavioral;

