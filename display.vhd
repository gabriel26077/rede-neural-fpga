library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is

	port 
	(
		x0, x1, x2         : in std_logic;
		a, b, c, d, e, f, g: out std_logic
	);

end entity;

architecture behaviour of display is
begin

	a <= not((not(x0) and not(x1) and not(x2)) or
	    (x0 and not(x1) and not(x2)));
		 
	b <= (not(x0) and not(x1) and x2) or 
		  (not(x0) and x1 and x2) or
		  (x0 and not(x1) and x2) or 
		  (x0 and x1 and x2);
		  
	c <= (not(x0) and x1 and x2) or 
		  (x0 and not(x1) and x2) or
		  (x0 and x1 and x2);
		  
	d <= (not(x0) and not(x1) and not(x2)) or 
		  (not(x0) and x1 and not(x2)) or
		  (x0 and x1 and not(x2)) or 
		  (x0 and x1 and x2);
		  
	e <= (not(x0) and x1 and not(x2)) or 
		  (x0 and x1 and not(x2)) or
		  (x0 and x1 and x2);
		  
	f <= (not(x0) and x1 and not(x2)) or 
		  (x0 and x1 and not(x2)) or
		  (x0 and x1 and x2);
		  
	g <= (not(x0) and x1 and not(x2)) or 
		  (not(x0) and x1 and x2) or
		  (x0 and not(x1) and not(x2)) or 
		  (x0 and x1 and x2);	

end behaviour ;
