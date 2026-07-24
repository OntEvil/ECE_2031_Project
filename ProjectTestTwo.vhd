-- ProjectTestTwo.vhd (VHDL)
-- SCOMP peripheral for switches with four modes.
-- Each mode can be accessed using a different IO address.
-- 	Regular			 0x60: The state of the switches as a bit string with high 6 bits as zero
-- 	Inverse			 0x61: Logical NOT of Regular mode with high 7 bits as zero
-- 	Sign Extended	 0x62: Regular mode with the six highested bits sign extended
-- 	Number Active	 0x63: Number of high switches in binary
-- Team L03_3
-- ECE 2031
-- 7/23/2026
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ProjectTestTwo is
	port(
		IO_ADDR     : IN    STD_LOGIC_VECTOR(10 DOWNTO 0);
		IO_READ     : IN    STD_LOGIC;
		EXT_WIRES   : IN    STD_LOGIC_VECTOR(15 DOWNTO 0);
		IO_DATA     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
end entity;

architecture rtl of ProjectTestTwo is

	-- Build an enumerated type for the state machine
	type state_type is (default, inverse, mSigned, switchCount,none);

	-- Register to hold the current state
	signal state   : state_type;

	signal signBit : std_logic_vector(0 downto 0);
	signal absValue : std_logic_vector(15 downto 0);
	signal temp : std_logic_vector(8 downto 0);
	begin
	
	state <= default	 when (IO_ADDR = "00001100000" and IO_READ = '1') else
			 inverse	 when (IO_ADDR = "00001100001" and IO_READ = '1') else
			 mSigned	 when (IO_ADDR = "00001100010" and IO_READ = '1') else
			 switchCount when (IO_ADDR = "00001100011" and IO_READ = '1') else
			 none;
	
	Process(IO_ADDR,IO_READ, EXT_WIRES, state) 
	variable count: integer range 0 to 10;

	begin 
		count := 0;
		
		case state is
			when default =>
				IO_DATA <= "000000"&EXT_WIRES(9 DOWNTO 0);
				
			when mSigned =>
				signBit <= EXT_WIRES(9 DOWNTO 9);
			
				if (signBit = "0") then
					IO_DATA <=  EXT_WIRES;
				else
					temp <= not EXT_WIRES(8 DOWNTO 0);
					IO_DATA <=  "1111111"&std_logic_vector(Unsigned(temp) + 1);
				end if;
				
			when switchCount =>
				
				for i in 0 to 9 loop
					if (EXT_WIRES(i) = '1') then 
						count := count + 1;
					end if;
				end loop;
				IO_DATA <= std_logic_vector(to_unsigned(count, IO_DATA'length));
			
			when inverse => 
				IO_DATA <= "000000"&(not EXT_WIRES(9 DOWNTO 0));
				
			when others => 
				IO_DATA <= "ZZZZZZZZZZZZZZZZ";
				
		end case;

	END PROCESS;
END rtl;
	
	
	
