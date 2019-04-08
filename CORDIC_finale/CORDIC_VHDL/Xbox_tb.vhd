library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--	This testbench has been used to test the correctness of Xbox with a variety of inputs.

    entity Xbox_tb is
       
	end Xbox_tb;
   
	architecture testbench of Xbox_tb is
   
    -----------------------------------------------------------------------------------------------------
	-- components declaration
	-----------------------------------------------------------------------------------------------------
   
        component Xbox is    --! component declaration
			generic (N : integer :=16; M : integer := 3);
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
	
		end component;
   
	-----------------------------------------------------------------------------------------------------
	-- constants declaration
	-----------------------------------------------------------------------------------------------------
		-- CLK period
		constant T_CLK  : time := 100 ns;
		-- Simulation time
		constant T_sim  : time := 1000 ns;
		-- Number of bits of the Xbox
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
		signal x_tb, yi_tb, xi_tb             	: std_logic_vector(N_bit - 1 downto 0);
		signal i_tb             	: std_logic_vector(M_bit - 1 downto 0);
		-- output signals (the declaration is useful to make it visible without observing the Xbox signals
		signal o_tb                   	: std_logic_vector(N_bit - 1 downto 0);

	   
	begin
   
        -- clk variation
	    clk_tb                 <= (not(clk_tb) and stop_simulation) after T_CLK / 2;
		
		-- stopping the simulation after T_sim
		stop_simulation        <= '0' after T_sim;
		
		test_Xbox: Xbox
        
		 	generic map(N => N_bit, M => M_bit)
	   
            		port map(
                    		x    => x_tb,
                    		y_i    => yi_tb,                    
							o  => o_tb,
							x_i=> xi_tb,
							i    => i_tb,
							clk => clk_tb,
							rst_low => rst_tb
	                );
		
		input_process : process(clk_tb)
		
		    --! variable to control the number of clock cycles
			variable t : natural := 0;
			
		
		begin
		   
		    if(rising_edge(clk_tb) ) then
			 
			    case t is
				
				    	when 0       => rst_tb <= '0';
							x_tb <= std_logic_vector(to_signed(1536, N_bit));		-- 6
					                yi_tb <= std_logic_vector(to_signed(2304, N_bit));            
							i_tb <= std_logic_vector(to_unsigned(0, M_bit));  
						
						when 1	=> rst_tb <= '1';

				    	when 10       => rst_tb <= '0';
							x_tb <= std_logic_vector(to_signed(1536, N_bit));
					                yi_tb <= std_logic_vector(to_signed(-2304, N_bit));            
							i_tb <= std_logic_vector(to_unsigned(0, M_bit));
						
						when 11	=> rst_tb <= '1';
				    		
					
						when others => null;
					
				end case;
			 
			 
			-- incrementing t
			t := t + 1;
			end if;
			 	
		
		end process;
		
        
   end testbench;