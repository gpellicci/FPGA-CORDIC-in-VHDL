library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

--	Counter circuit made of Full adders + register.
--  Full adder sum always one to the register value so that it actually count.

    entity Counter is
	    generic( M : integer := 3);	
		
        port( 
			-- Clk and reset
			clk   : in std_logic;
			rst_low : in std_logic;
			-- Output
			q     : out std_logic_vector(M - 1 downto 0)
		);
    end Counter;
	
  
	architecture struct of Counter is
		--------------------------------------------------------------
		-- Signals declaration
		--------------------------------------------------------------

		-- Output of the DFF_N
		signal q_h : std_logic_vector(M - 1 downto 0);
		-- fixed increment is 1 in our case
		signal fixed_increment : std_logic_vector(M - 1 downto 0) := std_logic_vector(to_signed(1, M));		
		-- Output of the fullAdder_N
		signal fullAdder_out : std_logic_vector(M - 1 downto 0);
		
		--------------------------------------------------------------
		-- Components declaration
		--------------------------------------------------------------
	
		component DFF_N is
			generic( N : natural);
			
			port( -- Input of the register
				d     : in std_logic_vector(N - 1 downto 0);
				-- Clk and reset
				clk   : in std_logic;
				rst_low : in std_logic;
				-- Output of the register
				q     : out std_logic_vector(N - 1 downto 0)
			);	
		end component;
	
		component fullAdder_N is
		   generic (N : integer);
		   
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
		end component;
	
	
	begin
   
		FULL_ADDER_N_MAP :  fullAdder_N 
       		generic map(N => M)
       	 	port map(-- Input of the full-adder
				a   => fixed_increment,
				-- Input of the full-adder
				b   => q_h,
				-- Carry input 
				c_i => '0',
				-- Output of the full-adder
				o   => fullAdder_out,
				-- Carry output
				c_o => open
            );
			
		DFF_N_MAP : DFF_N 	
			generic map(N => M)
			port map( -- Input of the register
				d     => fullAdder_out,
				-- Clk and reset
				clk   => clk, 
				rst_low => rst_low,
				-- Output of the register
				q     => q_h
			);	
		
	    -- Mapping the output
	    q <= q_h;
	   
	end struct;
    