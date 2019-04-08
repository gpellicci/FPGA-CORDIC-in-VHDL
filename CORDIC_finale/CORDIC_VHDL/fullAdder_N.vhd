library ieee;
    use ieee.std_logic_1164.all;

--	Full adder with N bit

	entity fullAdder_N is
       generic (N : integer := 2);
	   
        port(-- Input of the full-adder
            a   : in std_logic_vector(N - 1 downto 0);
            -- Input of the full-adder
            b   : in  std_logic_vector(N - 1 downto 0);
            -- Carry input 
            c_i : in std_logic;
            -- Output of the full-adder
            o   : out  std_logic_vector(N - 1 downto 0);
            -- Carry output
            c_o : out std_logic
            );
	end fullAdder_N;
   
   architecture struct of fullAdder_N is
   
    --------------------------------------------------------------
	-- Components declaration
	--------------------------------------------------------------
   
        component fullAdder is                -- component declaration
		    port(-- Input of the full-adder
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
		end component;
		
	--------------------------------------------------------------
	-- Signals declaration
	--------------------------------------------------------------
   
	-- Vector used to contain the internal carry signals
	signal c_int : std_logic_vector(N  downto 0);
	   
	   
	begin
        
		n_full_adder_gen : for i in 0 to N - 1  generate
	
			i_full_adder : fullAdder port map(
		                                    a    =>  a(i),
							     			b    =>  b(i), 
										    c_i  =>  c_int(i),
											o    =>  o(i),
											c_o  =>  c_int(i + 1)
							            );
	       
	     end generate;
			
		-- Input carry mapping
		c_int(0) <= c_i;
		-- Output carry mapping
		c_o       <= c_int(N);
		
		
	end struct;
    