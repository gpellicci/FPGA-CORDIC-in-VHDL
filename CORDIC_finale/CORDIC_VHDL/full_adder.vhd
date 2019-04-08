library ieee;
    use ieee.std_logic_1164.all;

--	Basic component of a fullAdder_N


    entity fullAdder is
        port( -- Input of the full-adder
			a   : in std_logic;
			-- Input of the full-adder
			b   : in std_logic;
			-- Carry input 
			c_i : in std_logic;
			-- Output of the full-adder
			o   : out std_logic;
			-- Carry output
			c_o : out std_logic
		);
    end fullAdder;
	
	
	architecture data_flow of fullAdder is
   
	begin
   
		o   <= a xor b xor c_i;
      
		c_o <= (a and b) or (b and c_i) or (c_i and a);
   
	end data_flow;
    