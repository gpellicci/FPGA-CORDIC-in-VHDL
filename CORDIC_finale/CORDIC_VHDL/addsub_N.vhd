library ieee;
    use ieee.std_logic_1164.all;

--	Special circuit capable to do both sum and subtraction, given the command cmd. Result is o = a + cmd*b + c_i
--	This circuit is exploited in all the iterative block Xbox, Ybox, Zbox

   entity addSub_N is
       generic (N : integer := 2);
	   
        port(-- Input of the add-sub
            a   : in std_logic_vector(N - 1 downto 0);
            b   : in  std_logic_vector(N - 1 downto 0);
            -- Carry input 
            c_i : in std_logic;
			-- Cmd
			cmd : in std_logic;
            -- Output of the add-sub
            o   : out  std_logic_vector(N - 1 downto 0);
            -- Carry output
            c_o : out std_logic;
			-- Overflow 
			overflow : out std_logic
		);
	end addSub_N;
   
   architecture struct of addSub_N is
		
		--------------------------------------------------------------
		-- Components declaration
		--------------------------------------------------------------
   
        component fullAdder is                -- component declaration
		    port(-- Input of the full-adder
                 a   : in std_logic;
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
		signal b_in : std_logic_vector(N-1 downto 0);
	   
	   
	begin
        
		n_full_adder_gen : for i in 0 to N - 1  generate
	
			b_in(i) <= b(i) xor cmd;

	    	i_full_adder : fullAdder port map(
		        a    =>  a(i),
				b    =>  b_in(i), 
				c_i  =>  c_int(i),
				o    =>  o(i),
				c_o  =>  c_int(i + 1)
			);
	       
		end generate;
			
		-- Input carry mapping
		c_int(0) <= c_i xor cmd;
		-- Output carry mapping
		c_o       <= c_int(N) xor cmd;
		-- Overflow mapping
		overflow <= c_int(N) xor c_int(N-1);
   
   end struct;
    