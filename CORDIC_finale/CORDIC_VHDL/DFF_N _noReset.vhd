library ieee;
    use ieee.std_logic_1164.all;

--Special purpose N bit register without enable, allowing data memorization even without clock when reset command is issued.
--It's used both in the Xbox and in the Ybox

    entity DFF_N_noReset is
	    generic( N : natural := 16);
		
        port( -- Input of the register
			d     : in std_logic_vector(N - 1 downto 0);
			-- Clk and reset
			clk   : in std_logic;
			rst_low : in std_logic;
			-- Output of the register
			q     : out std_logic_vector(N - 1 downto 0)
		);	
    end DFF_N_noReset;

	
	architecture struct of DFF_N_noReset is
   
	begin
   
        ddf_n_proc: process(clk, rst_low, d)
		begin
			if(rst_low = '0') then
				q <= d;
			elsif(rising_edge(clk)) then
				q <= d;
			end if;
		end process;
   
   end struct;
    