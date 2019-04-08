library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

--	This entity is a simple multiplexer with 2 ways, allowing A or B to pass depending on the SEL value
--  This multiplexer is used in the Xbox and in the Ybox to pass the initial input value when reset is given
-- (therefore SEL will be connected with the reset), otherwise the value calculated in the last iteration is passed 

	entity mux is
		generic(N : integer);
		port (--Input of the multiplexer
			SEL : in  STD_LOGIC;
			A   : in  STD_LOGIC_VECTOR (N-1 downto 0);
			B   : in  STD_LOGIC_VECTOR (N-1 downto 0);
			--Output of the multiplexer
			X   : out STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end mux;
	

	architecture Behavioral of mux is
	
	begin
		X <= A when (SEL = '0') else B;
		
	end Behavioral;