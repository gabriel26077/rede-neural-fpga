library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is

	port 
	(
		inf, class				: in std_logic;
		d0, d1, d2, d3, d4	: out std_logic_vector(6 DOWNTO 0)
	);

end entity;

architecture behaviour of decoder is
	component display
		port ( x0, x1, x2          : in std_logic;
			    a, b, c, d, e, f, g : out std_logic
		);
	end component;
	
	signal x0_d, x1_d, x2_d : std_logic_vector(4 DOWNTO 0);
	
begin
	x0_d(0) <= not(inf);
	x0_d(1) <= not(inf);
	x0_d(2) <= (class and inf) or not(inf);
	x0_d(3) <= (not(class) and inf) or (class and inf) or not(inf);
	x0_d(4) <= (not(class) and inf) or (class and inf) or not(inf);
	
	x1_d(0) <= not(inf);
	x1_d(1) <= (class and inf) or not(inf);
	x1_d(2) <= (not(class) and inf) or not(inf);
	x1_d(3) <= (not(class) and inf) or not(inf);
	x1_d(4) <= (class and inf) or not(inf);
	
	x2_d(0) <= (not(class) and inf) or not(inf);
	x2_d(1) <= (class and inf) or not(inf);
	x2_d(2) <= (class and inf) or not(inf);
	x2_d(3) <= not(inf);
	x2_d(4) <= (class and inf) or not(inf);
	

	display0 : display port map (x0 => x0_d(0), x1 => x1_d(0), x2 => x2_d(0), a => d0(0), b => d0(1), c => d0(2), d => d0(3), e => d0(4), f => d0(5), g => d0(6));
	display1 : display port map (x0 => x0_d(1), x1 => x1_d(1), x2 => x2_d(1), a => d1(0), b => d1(1), c => d1(2), d => d1(3), e => d1(4), f => d1(5), g => d1(6));
	display2 : display port map (x0 => x0_d(2), x1 => x1_d(2), x2 => x2_d(2), a => d2(0), b => d2(1), c => d2(2), d => d2(3), e => d2(4), f => d2(5), g => d2(6));
	display3 : display port map (x0 => x0_d(3), x1 => x1_d(3), x2 => x2_d(3), a => d3(0), b => d3(1), c => d3(2), d => d3(3), e => d3(4), f => d3(5), g => d3(6));
	display4 : display port map (x0 => x0_d(4), x1 => x1_d(4), x2 => x2_d(4), a => d4(0), b => d4(1), c => d4(2), d => d4(3), e => d4(4), f => d4(5), g => d4(6));
   
	

end behaviour ;
