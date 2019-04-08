library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--	This testbench is used to test Zbox correctness and provided us significant results with different inputs.

    entity Zbox_tb is
       
	end Zbox_tb;
   
   architecture testbench of Zbox_tb is
   
    -----------------------------------------------------------------------------------------------------
	-- components declaration
	-----------------------------------------------------------------------------------------------------
   
        component Zbox is    --! component declaration
			generic (N : integer :=16; M : integer := 3);
			port(-- Input of the Zbox
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
	
		end component;
   
	-----------------------------------------------------------------------------------------------------
	-- constants declaration
	-----------------------------------------------------------------------------------------------------
		-- CLK period
		constant T_CLK  : time := 100 ns;
		-- Simulation time
		constant T_sim  : time := 10000 ns;
		-- Number of bits of the Zbox
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
		signal di_tb             	: std_logic;
		signal i_tb             	: std_logic_vector(M_bit - 1 downto 0);
		-- output signals (the declaration is useful to make it visible without observing the Zbox signals
		signal o_tb                   	: std_logic_vector(N_bit - 1 downto 0);


	   
	begin
   
        -- clk variation
	    clk_tb                 <= (not(clk_tb) and stop_simulation) after T_CLK / 2;
		
		-- stopping the simulation after T_sim
		stop_simulation        <= '0' after T_sim;
		
		test_Zbox: Zbox
        
		 	generic map(N => N_bit, M => M_bit)
	   
            		port map(
                    		d_i    => di_tb,
							o  => o_tb,
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
									di_tb <= '0';
					                         
							i_tb <= std_logic_vector(to_unsigned(0, M_bit));  
						when 1	=> rst_tb <= '1';

				    	when 2       =>             
							i_tb <= std_logic_vector(to_unsigned(1, M_bit));
						
						
						
						when 3 =>          
							i_tb <= std_logic_vector(to_unsigned(2, M_bit));
						
						when 4 =>         
							i_tb <= std_logic_vector(to_unsigned(3, M_bit));
						
						when 5 =>         
							i_tb <= std_logic_vector(to_unsigned(4, M_bit));
						
						when 6 =>         
							i_tb <= std_logic_vector(to_unsigned(5, M_bit));

						when 7 =>         
							i_tb <= std_logic_vector(to_unsigned(6, M_bit));

						when 8 =>         
							i_tb <= std_logic_vector(to_unsigned(7, M_bit));
				    		
				    	when 15 =>  rst_tb <= '0';
									di_tb <= '1';          
									i_tb <= std_logic_vector(to_unsigned(0, M_bit));  

						when 16	=> rst_tb <= '1';

				    	when 17       =>         
							i_tb <= std_logic_vector(to_unsigned(1, M_bit));
						
						
						
						when 18 =>          
							i_tb <= std_logic_vector(to_unsigned(2, M_bit));
						
						when 19 =>         
							i_tb <= std_logic_vector(to_unsigned(3, M_bit));
						
						when 20 =>         
							i_tb <= std_logic_vector(to_unsigned(4, M_bit));
						
						when 21 =>         
							i_tb <= std_logic_vector(to_unsigned(5, M_bit));

						when 22 =>         
							i_tb <= std_logic_vector(to_unsigned(6, M_bit));

						when 23 =>         
							i_tb <= std_logic_vector(to_unsigned(7, M_bit));

					
						when others => null;
					
				end case;
			 
			 
			-- incrementing t
			t := t + 1;
			end if;
			 	
		
		end process;
		
        
   end testbench;