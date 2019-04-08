library ieee;
    use ieee.std_logic_1164.all;

--	D FF used as register with enable, N generic input/output (bits) 


    entity DFF_N_en is
	    generic( N : natural);
		
        port( -- Input of the register
			d     : in std_logic_vector(N - 1 downto 0);
			-- Clock of the system
			clk   : in std_logic;
			-- Reset 
			rst_low : in std_logic;
			-- Enable
			en     : in std_logic;
			-- Output of the register
			q     : out std_logic_vector(N - 1 downto 0)
		);
	end DFF_N_en;

	
	architecture struct of DFF_N_en is
   
	begin
   
        ddf_n_en_proc: process(clk, rst_low)
		begin
			if(rst_low = '0') then
				q <= (others => '0');
			elsif(rising_edge(clk)) then
				if(en = '1') then
					q <= d;
				end if;
			end if;
		end process;
   
   end struct;
    