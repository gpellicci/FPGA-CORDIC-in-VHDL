library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--	This testbench is used to test Ybox correctness and provided us significant results with different inputs.

    entity Ybox_tb is
       
	end Ybox_tb;
   
   architecture testbench of Ybox_tb is
   
    -----------------------------------------------------------------------------------------------------
	-- components declaration
	-----------------------------------------------------------------------------------------------------
   
        component Ybox is    --! component declaration
			generic (N : integer :=16; M : integer := 3);
			port(-- Input of the Ybox
				x_i   : in std_logic_vector(N - 1 downto 0);
	            y   : in  std_logic_vector(N - 1 downto 0);
				-- Output of Ybox
	            o   : out  std_logic_vector(N - 1 downto 0);
	            y_i   : out  std_logic_vector(N - 1 downto 0);
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
		constant T_sim  : time := 10000 ns;
		-- Number of bits of the Ybox
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
		signal xi_tb, y_tb, yi_tb             	: std_logic_vector(N_bit - 1 downto 0);
		signal i_tb             	: std_logic_vector(M_bit - 1 downto 0);
		-- output signals (the declaration is useful to make it visible without observing the Ybox signals
		signal o_tb                   	: std_logic_vector(N_bit - 1 downto 0);


	   
	begin
   
        -- clk variation
	    clk_tb                 <= (not(clk_tb) and stop_simulation) after T_CLK / 2;
		
		-- stopping the simulation after T_sim
		stop_simulation        <= '0' after T_sim;
		
		test_Ybox: Ybox
        
		 	generic map(N => N_bit, M => M_bit)
	   
            		port map(
                    		x_i    => xi_tb,
                    		y    => y_tb,
							o  => o_tb,
							y_i	=>	yi_tb,
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
							xi_tb <= std_logic_vector(to_signed(1536, N_bit));
					                y_tb <= std_logic_vector(to_signed(2304, N_bit));            
							i_tb <= std_logic_vector(to_unsigned(1, M_bit));  
						when 1	=> rst_tb <= '1';

						when 2 => null;

				    	when 3       => rst_tb <= '0';
							xi_tb <= std_logic_vector(to_signed(1536, N_bit));
					                y_tb <= std_logic_vector(to_signed(-2304, N_bit));            
							i_tb <= std_logic_vector(to_unsigned(0, M_bit));
						
						when 4	=> rst_tb <= '1';
						
						when 5 =>          
							i_tb <= std_logic_vector(to_unsigned(1, M_bit));
						
						when 6 =>         
							i_tb <= std_logic_vector(to_unsigned(2, M_bit));
						
						when 7 =>         
							i_tb <= std_logic_vector(to_unsigned(3, M_bit));
						
						when 8 =>         
							i_tb <= std_logic_vector(to_unsigned(4, M_bit));
				    		
					
						when others => null;
					
				end case;
			 
			 
			-- incrementing t
			t := t + 1;
			end if;
			
		
		end process;
		
        
   end testbench;