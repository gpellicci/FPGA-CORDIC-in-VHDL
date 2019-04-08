library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--	This block implements the final multiplier used to obtain the correct module(rho) out of Xn (rho = Xn * Kn)

entity multiplier is

    generic (N : integer; M : integer);
  	port
   	(
		--Input of the multiplier
      	a: in std_logic_vector(N - 1 downto 0);
		b: in std_logic_vector(M - 1 downto 0);
		--Output of the multiplier
     	o: out std_logic_vector(N + M - 1 downto 0)
   );
end multiplier;

architecture bhv of multiplier is
begin

   o <= std_logic_vector(unsigned(a) * unsigned(b));

end bhv;