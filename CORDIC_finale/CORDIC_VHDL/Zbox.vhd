library ieee;
    use ieee.std_logic_1164.all;

-- 	This entity has the purpose of computing  Zi+1 given Zi(internally known) and the sign of Yi.
--	Given the current iteration the corresponding arctan value is retrieved from the LUT and added or 
--	subtracted (based on the sign of Yi) from the Zi to obtain Zi+1

	entity Zbox is
		generic (N : integer; M : integer);
		
        port(
		    -- Iteration number i
		    i   : in std_logic_vector(M - 1 downto 0);
		    -- Command for add or sub
		    d_i	: in std_logic;
		    -- Output of Zbox
	        o   : out  std_logic_vector(N - 1 downto 0);
			--Clk and reset
		    clk	: in std_logic;
		    rst_low	: in std_logic
        );
	end Zbox;
   
   
	architecture struct of Zbox is
		
		--------------------------------------------------------------
		-- Components declaration
		--------------------------------------------------------------
   
		component addsub_N is                
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

		component cordic_lut_16 is 
			port(   -- lut address
				address : in std_logic_vector(2 downto 0);		-- 8 location can be addressed with 3 bits
				-- lut data output
				d_out : out std_logic_vector(15 downto 0)		-- 16 bit fixed point
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
		
		--------------------------------------------------------------
		-- Signals declaration
		--------------------------------------------------------------

	    -- Vector used to contain the internal carry signals
		signal lut_output : std_logic_vector(N-1  downto 0);
		signal reg_out : std_logic_vector(N-1  downto 0);
		signal z_out : std_logic_vector(N-1  downto 0);

	   
	begin
  
	    cordic_lut_16_map : cordic_lut_16
			port map(
				address =>	i,
				d_out	=>	lut_output 
			);

		DFF_N_map : DFF_N
			generic map (N => N)
			port map(
				d		=>	z_out,
				clk		=>	clk,
				rst_low	=>	rst_low,
				q		=>	reg_out
			);

	    addsub_N_map : addsub_N 
        	generic map(N => N)
			port map(
				a    	=>  	reg_out,
				b    	=>  	lut_output, 
				c_i		=>		'0',
				cmd    	=>  	d_i,
				o		=>  	z_out,
				c_o		=> 		open,
				overflow => open
			);

		o <= z_out;

   end struct;
    