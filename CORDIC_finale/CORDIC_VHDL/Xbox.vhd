library ieee;
    use ieee.std_logic_1164.all;

-- This entity computes Xi+1 given Xi(internally known) and Yi and Yi's sign(Yi's most significant bit).

	entity Xbox is
       generic (N : integer; M : integer);
	   
        port(-- Input of Xbox
            x   : in std_logic_vector(N - 1 downto 0);
            y_i   : in  std_logic_vector(N - 1 downto 0);
			-- Output of Xbox
			o   : out  std_logic_vector(N - 1 downto 0);
			x_i : out std_logic_vector (N - 1 downto 0);
			-- Iteration number i
			i   : in std_logic_vector(M - 1 downto 0);
			--Clk and reset
			clk	: in std_logic;
			rst_low	: in std_logic
        );
	end Xbox;
   
   
	architecture struct of Xbox is
	
		--------------------------------------------------------------
		-- Components declaration
		--------------------------------------------------------------
   
        component addsub_N is                -- component declaration
			generic (N : integer);
	   
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
		end component;

		component shiftRight_i is
			generic(N : integer; M : integer);		-- make sure 
				
			port( 
				-- Input of the shift right
				input   : in std_logic_vector(N-1 downto 0);
				-- #position to shift right
				i   	: in std_logic_vector(M-1 downto 0);
				-- Shift right output
				o 	: out std_logic_vector(N-1 downto 0)
			);
		end component;

		component mux is
			generic(N : integer);
			
			port (--Input of the multiplexer
				SEL : in  STD_LOGIC;
				A   : in  STD_LOGIC_VECTOR (N-1 downto 0);
				B   : in  STD_LOGIC_VECTOR (N-1 downto 0);
				--Output of the multiplexer
				X   : out STD_LOGIC_VECTOR (N-1 downto 0)
			);
		end component;

		component DFF_N is 	    
			generic( N : natural := 16);
			
			port( -- Input of the register
				d     : in std_logic_vector(N - 1 downto 0);
				-- Clk and reset
				clk   : in std_logic; 
				rst_low : in std_logic;
				-- Output of the register
				q     : out std_logic_vector(N - 1 downto 0)
			);
		end component; 

		component DFF_N_noReset is 	    
			generic( N : natural := 16);
			
			port( -- Input of the register
				d     : in std_logic_vector(N - 1 downto 0);
				-- Clk and reset
				clk   : in std_logic;
				rst_low : in std_logic;
				-- Output of the register
				q     : out std_logic_vector(N - 1 downto 0)
			);
		end component;
		
		--------------------------------------------------------------
		-- Signals declaration
		--------------------------------------------------------------
	
	    -- Vector used to contain the internal carry signals
		signal shift_output : std_logic_vector(N-1  downto 0);
		signal x_out : std_logic_vector(N-1  downto 0);
		signal x_to_reg : std_logic_vector(N-1  downto 0);
		signal reg_out : std_logic_vector(N-1  downto 0);
	   
	begin

		mux_map	: mux
			generic map(N => N)
			port map(
				SEL	=>	rst_low,
				A	=>	x,
				B	=>	x_out,
				X	=>	x_to_reg
			);

		DFF_N_noReset_map : DFF_N_noReset
			generic map (N => N)
			port map(
				d	=>	x_to_reg,
				clk	=>	clk,
				rst_low	=>	rst_low,
				q	=>	reg_out
			);

	    shiftRight_i_map : shiftRight_i 
        	generic map(N => N, M => M)
			port map(
				input    =>  y_i,
				i    =>  i, 
				o    =>  shift_output
			);
	       
	    addsub_N_map : addsub_N 
        	generic map(N => N)
			port map(
		        a    	=>  	reg_out,
				b    	=>  	shift_output, 
				c_i 	=>		'0',
				cmd    	=>  	y_i(N - 1),
				o	=>  	x_out,
				c_o	=> 	open,
				overflow => open
			);

		o <= x_out;
		x_i <= reg_out;
	
	end struct;
    