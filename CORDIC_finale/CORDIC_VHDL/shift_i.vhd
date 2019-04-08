library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;               -- Needed for shifts

--	This entity allow you to shift to the right N bit of i location, obtaining the shifted value on output.
--	This block is the one which implements the 2^-i "fake" multiplication


    entity shiftRight_i is
		generic(N : integer; M : integer);		-- make sure 
			port( 
				-- Input of the shift right
				input   : in std_logic_vector(N-1 downto 0);
				-- #position to shift right
				i   	: in std_logic_vector(M-1 downto 0);
				-- Shift right output
				o 	: out std_logic_vector(N-1 downto 0)
			);
    end shiftRight_i;
   
   
	architecture data_flow of shiftRight_i is
      	
	begin
		
		o <= std_logic_vector(shift_right(signed(input), to_integer(unsigned(i))));
		
	end data_flow;
    