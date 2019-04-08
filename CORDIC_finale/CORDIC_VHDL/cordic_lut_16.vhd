library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;
	
-- LUT table containing arctan() values. Stored values are computed thanks to a JAVA utility made by us.
-- You can address the arctan(2^-i) by accessing the i-th location.

	entity cordic_lut_16 is 
		port(   -- lut address
			address : in std_logic_vector(2 downto 0);		-- 8 location can be addressed with 3 bits
			-- lut data output
			d_out : out std_logic_vector(15 downto 0)		-- 16 bit fixed point
		);
	end cordic_lut_16;


	architecture bhv of cordic_lut_16 is
		-------------------------------------------------------------------------------------
		-- Internal signals & constants
		-------------------------------------------------------------------------------------
		-- lut_t type declaration
		subtype lutout is std_logic_vector (15 downto 0);
		type lut_t is array (natural range 0 to 7) of lutout;

		-- Look up table cells
        constant lut : lut_t := (
            "0000000011001001",
            "0000000001110111",
            "0000000000111111",
            "0000000000100000",
            "0000000000010000",
            "0000000000001000",
            "0000000000000100",
            "0000000000000010"
        );
		-- LUT address converted to integer to be used ad array index
		signal lut_address_index : integer range 0 to 15; 
			
	begin
		   
		-- Converting the lut address into an integer to be usable as array index
		lut_address_index <= to_integer(unsigned(address));
	   
		-- Selecting the lut cell depending on the index lut_address_index
		d_out <= lut(lut_address_index);

	end bhv;