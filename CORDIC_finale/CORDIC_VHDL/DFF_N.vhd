library ieee;
    use ieee.std_logic_1164.all;

--	D FF used as register without enable, used when enable is not needed. 
--	It's used only in the Zbox

    entity DFF_N is
	    generic( N : natural := 16);
		
        port( -- Input of the register
			d     : in std_logic_vector(N - 1 downto 0);
			-- Clk and reset
			clk   : in std_logic;
			rst_low : in std_logic;
			-- Output of the register
			q     : out std_logic_vector(N - 1 downto 0)
		);
    end DFF_N;
	
	
	architecture struct of DFF_N is
   
	begin
   
        ddf_n_proc: process(clk, rst_low)
		begin
			if(rst_low = '0') then
				q <= (others => '0');
			elsif(rising_edge(clk)) then
				q <= d;
			end if;
		end process;
   
   end struct;
    