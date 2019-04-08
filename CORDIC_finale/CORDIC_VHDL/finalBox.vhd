library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

--	This is the highest level entity. In this block we interconnected the counter with Xbox, Ybox, Zbox, multiplier 
--	and added some logic in order to guarantee the stability of the output result with a data_valid signal.
--	Counter gives the current iteration i to all the other blocks, while Xbox, Ybox, Zbox compute respectively X(i+1), Y(i+1) and Z(i+1). 
--	When iteration 8 is reached the logic set the data_valid output, enable the register for one clock cycle in order
--	to store the results (rho, theta). Then the logic prevents the enable to be setted again unless a new computation
--	command is issued (by giving new inputs and resetting the device). 


	entity finalBox is
		generic (N : integer := 16;M : integer :=3);
		
        port(
		    -- Input of finalBox
		    x   : in std_logic_vector(N - 1 downto 0);
		    y   : in std_logic_vector(N - 1 downto 0);
		    -- Output of finalBox
	        rho   : out  std_logic_vector(N+N - 1 downto 0);
	        theta   : out  std_logic_vector(N+N - 1 downto 0);
	        data_valid : out std_logic;
	        -- Clock
		    clk	: in std_logic;
			-- Reset
		    rst_low	: in std_logic
        );
	end finalBox;
   
	
	architecture struct of finalBox is
	
		--------------------------------------------------------------
		-- Components declaration
		--------------------------------------------------------------
   
		component Xbox is                
			generic (N : integer; M : integer);
		   
			port(-- Input of Xbox
				x   	: in std_logic_vector(N - 1 downto 0);
				y_i   	: in  std_logic_vector(N - 1 downto 0);
				-- Output of Xbox
				o   	: out  std_logic_vector(N - 1 downto 0);
				x_i   	: out  std_logic_vector(N - 1 downto 0);
				-- Iteration number i
				i   	: in std_logic_vector(M - 1 downto 0);
				-- Clk and reset
				clk		: in std_logic;
				rst_low	: in std_logic
			);
		end component;

		component Ybox is                -- component declaration
			generic (N : integer; M : integer);
		   
			port(-- Input of Ybox
				x_i   : in std_logic_vector(N - 1 downto 0);
				y   : in  std_logic_vector(N - 1 downto 0);
				-- Output of Ybox
				o   : out  std_logic_vector(N - 1 downto 0);
				y_i   : out  std_logic_vector(N - 1 downto 0);
				-- Iteration number i
				i   : in std_logic_vector(M - 1 downto 0);
				-- Clk and reset
				clk	: in std_logic;
				rst_low	: in std_logic
			);
		end component;

		component Zbox is
		   generic (N : integer; M : integer);

			port(
				-- Iteration number i
				i   : in std_logic_vector(M - 1 downto 0);
				-- Command for add or sub
				d_i	: in std_logic;
				-- Output of Zbox
				o   : out  std_logic_vector(N - 1 downto 0);
				-- Clk and reset
				clk	: in std_logic;
				rst_low	: in std_logic
			);
		end component;

		component Counter is
			generic( M : integer := 3);

			port( 
				-- Clk and reset
				clk   : in std_logic;
				rst_low : in std_logic;
				-- Output of the counter
				q     : out std_logic_vector(M - 1 downto 0)
			);
		end component;

		component DFF_N_en is 	    
			generic( N : integer);
			
			port( -- Input of the register
				d     : in std_logic_vector(N - 1 downto 0);
				-- Enable signal (do not memorize if en = 0)
				en 		: in std_logic;
				-- Clk and reset
				clk   : in std_logic;
				rst_low : in std_logic;
				-- Output of the register
				q     : out std_logic_vector(N - 1 downto 0)
			);
		end component; 

		component multiplier is
			generic (N : integer; M : integer);

			port
		   	(
				--Input of the multiplier
		      	a: in std_logic_vector(N - 1 downto 0);
				b: in std_logic_vector(M - 1 downto 0);
				--Output of the multiplier
		     	o: out std_logic_vector(N + M - 1 downto 0)
		   	);
		end component;

		--------------------------------------------------------------
		-- Signals declaration
		--------------------------------------------------------------
		
	    -- Counter output signal and data_valid realization signals
		signal count : std_logic_vector(M - 1  downto 0);
		signal N_ITERATION : std_logic_vector(M - 1 downto 0) := "110";
		signal N_ITERATION_plus_1 : std_logic_vector(M - 1 downto 0) := "111";
		
		-- Iteration signals
		signal x_i : std_logic_vector(N - 1 downto 0);
		signal y_i : std_logic_vector(N - 1 downto 0);

		-- Final result of N Iteration
		signal x_N : std_logic_vector(N - 1 downto 0);
		signal z_N : std_logic_vector(N - 1 downto 0);
		--Zn extended to have it on the same number of bits as the module
		signal z_N_ext: std_logic_vector(N + N - 1 downto 0); 
		
		-- Signal to enable/disable output register
		signal en_reg	: std_logic;
		signal control_enable : std_logic;
		
		-- real module, after the multiplication with Kn = 1/An
		signal rho_signal	: std_logic_vector(N+N-1 downto 0);
		
		-- constant Kn = 1/An used to obtain the real module, starting from Xn
		signal Kn			: std_logic_vector(N - 1 downto 0) := "0000000010011011";
	   
	begin
  
	    Xbox_map : Xbox
			generic map (N => N, M => M)
			port map(
				x 		=>		x,
				y_i		=>		y_i, 
				o		=>		x_N,
				x_i		=>		x_i,
				i		=>		count,
				clk		=>		clk,
				rst_low	=>		rst_low		
			);

		Ybox_map : Ybox
			generic map (N => N, M => M)
			port map(
				x_i 	=>		x_i,
				y		=>		y, 
				o		=>		open,
				y_i		=>		y_i,
				i		=>		count,
				clk		=>		clk,
				rst_low	=>		rst_low		
			);

		Zbox_map : Zbox
			generic map (N => N, M => M)
			port map(
				o		=>		z_N,
				i		=>		count,
				d_i		=>		y_i(N - 1),
				clk		=>		clk,
				rst_low	=>		rst_low		
			);

		Counter_map : Counter
			generic map (M => M)
			port map(
				q		=>		count,
				clk		=>		clk,
				rst_low	=>		rst_low		
			);

		mul 	:	multiplier
			generic map (N => N, M => N)
			port map(
				a 	=>	x_N,
				b 	=>	Kn,
				o 	=>	rho_signal
			);

		rho_DFF_N : DFF_N_en
			generic map (N => N+N)
			port map(
				d 		=>		rho_signal,
				en 		=>		en_reg,
				clk 	=>		clk,
				rst_low =>		rst_low,
				q 		=>		rho
			);
		
		--Used to extend the phase (theta) signal. In this way we'll have the phase and the module on the same number of bits
		z_N_ext <= std_logic_vector(resize(signed(z_N), z_N_ext'length));
		
		theta_DFF_N : DFF_N_en
			generic map(N => N+N)
			port map(
				d 		=>		z_N_ext,
				en 		=>		en_reg,
				clk 	=>		clk,
				rst_low =>		rst_low,
				q 		=>		theta
			);	

		--control_enable is used to  prevent that the enable will be setted again unless a new computation
		--command is issued (by giving new inputs and resetting the device). data_valid becomes '1' when
		--the final results are ready (after the 8th iteration).
		finalBox_proc: process(clk, rst_low)
		begin
			if(rst_low = '0') then
				data_valid <= '0';
				en_reg <= '0';
				control_enable <= '0';
			elsif(rising_edge(clk)) then
				if(count = N_ITERATION) then
					if(control_enable = '0') then			
						en_reg <= '1';
						control_enable <= '1';
					end if;
				else
					en_reg <= '0';
				end if;
				if (count = N_ITERATION_plus_1) then
					data_valid <= '1';
				end if;
			end if;
		end process;

   end struct;
    