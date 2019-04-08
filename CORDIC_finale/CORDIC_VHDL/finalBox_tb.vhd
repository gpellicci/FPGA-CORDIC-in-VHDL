library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

--	This testbench is to test the integrity of the device and confirming the correctness of the system as a whole.
--	When this test was done the modules were already tested allowing us to perform this test just to verify if we connected 
--	everything as we should. Many inputs were given and the result was consistent with what was expected.

    entity finalBox_tb is
       
	end finalBox_tb;
   
   
	architecture testbench of finalBox_tb is
   
    -----------------------------------------------------------------------------------------------------
	-- components declaration
	-----------------------------------------------------------------------------------------------------
        component finalBox is    --! component declaration
			generic (N : integer :=16; M : integer := 3);
			
			port(-- Input of the finalBox
				x   : in std_logic_vector(N - 1 downto 0);
				y   : in  std_logic_vector(N - 1 downto 0);
			-- Output of finalBox
				rho   : out  std_logic_vector(N+N - 1 downto 0);
				theta   : out  std_logic_vector(N+N - 1 downto 0);
				data_valid : out std_logic;
			-- Clk and reset
				clk	: in std_logic;
				rst_low	: in std_logic
			);
		end component;
   
	-----------------------------------------------------------------------------------------------------
	-- constants declaration
	-----------------------------------------------------------------------------------------------------
		-- CLK period
		constant T_CLK  : time := 100 ns;
		-- Simulation time
		constant T_sim  : time := 100000 ns;
		-- Number of bits of the finalBox
		constant N_bit  : natural := 16;
		constant M_bit  : natural := 3;
		
    -----------------------------------------------------------------------------------------------------
	-- signals declaration
	-----------------------------------------------------------------------------------------------------
	    
		-- clk signal (intialized to '0')
		signal clk_tb                 	: std_logic := '0'; 
		signal rst_tb                 	: std_logic ; 
		-- signal to stop the simulation
		signal stop_simulation        	: std_logic := '1';
		-- inputs signals
		signal x_tb, y_tb            	: std_logic_vector(N_bit - 1 downto 0);
		-- output signals (the declaration is useful to make it visible without observing the finalBox signals
		signal rho_tb                   	: std_logic_vector(N_bit+N_bit - 1 downto 0);
		signal theta_tb                   	: std_logic_vector(N_bit+N_bit - 1 downto 0);
		signal dav_tb                   	: std_logic;

	   
	begin
   
        -- clk variation
	    clk_tb                 <= (not(clk_tb) and stop_simulation) after T_CLK / 2;
		
		-- stopping the simulation after T_sim
		stop_simulation        <= '0' after T_sim;
		
		test_finalBox: finalBox
		 	generic map(N => N_bit, M => M_bit)
			port map(
				x    => x_tb,
				y    => y_tb,
				rho  => rho_tb,
				theta  => theta_tb,
				data_valid  => dav_tb,
				clk => clk_tb,
				rst_low => rst_tb
			);
		
		input_process : process(clk_tb)
		
		    --! variable to control the number of clock cycles
			variable t : natural := 0;
			
		
		begin
		   
		    if(rising_edge(clk_tb) ) then
			 
			    case t is
				
				--test cases with various vector (X0,Y0) like: (2,3) (7,6) (11,13) (15,14)
					when 0       => rst_tb <= '0';
								x_tb <= std_logic_vector(to_signed(512, N_bit));	--2
								y_tb <= std_logic_vector(to_signed(768, N_bit));	--3  
								
					when 1	=> rst_tb <= '1';	

					when 20       => rst_tb <= '0';
								x_tb <= std_logic_vector(to_signed(1792, N_bit));	--7
								y_tb <= std_logic_vector(to_signed(1536, N_bit));	--6  
								
					when 21	=> rst_tb <= '1';	

					when 40       => rst_tb <= '0';
								x_tb <= std_logic_vector(to_signed(2816, N_bit));	--11
								y_tb <= std_logic_vector(to_signed(3328, N_bit));  	--13
								
					when 41	=> rst_tb <= '1';	

					when 60       => rst_tb <= '0';
								x_tb <= std_logic_vector(to_signed(3840, N_bit));	--15
								y_tb <= std_logic_vector(to_signed(3584, N_bit));  	--14
								
					when 61	=> rst_tb <= '1';	
					
					when others => null;
					
				end case;		 
			 
			-- incrementing t
			t := t + 1;
			end if;	 
		
		end process;
		    
	end testbench;