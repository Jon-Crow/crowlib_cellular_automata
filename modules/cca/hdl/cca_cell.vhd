library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;

entity cca_cell is
  generic (
    G_INIT   : std_logic_vector(3 downto 0) := (others => '0');
    G_CONFIG : std_logic_vector(3 downto 0) := (others => '0')
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;

    n     : in  std_logic_vector(3 downto 0);
    ne    : in  std_logic_vector(3 downto 0);
    e     : in  std_logic_vector(3 downto 0);
    se    : in  std_logic_vector(3 downto 0);
    s     : in  std_logic_vector(3 downto 0);
    sw    : in  std_logic_vector(3 downto 0);
    w     : in  std_logic_vector(3 downto 0);
    nw    : in  std_logic_vector(3 downto 0);

    state : out std_logic_vector(3 downto 0)
  );
end entity cca_cell;

architecture cca_cell_arch of cca_cell is

  signal state_d        : std_logic_vector(3 downto 0);
  signal state_q        : std_logic_vector(3 downto 0);
  signal tar_state      : std_logic_vector(3 downto 0);

  signal neighbors      : std_logic_vector(7 downto 0);
  signal neighbor_count : integer range 0 to 8;

begin

  state <= state_q;

  tar_state <= std_logic_vector(unsigned(state_q) + to_unsigned(1, 4));

  neighbors(0) <= '1' when n  = tar_state else '0';
  neighbors(1) <= '1' when ne = tar_state else '0';
  neighbors(2) <= '1' when e  = tar_state else '0';
  neighbors(3) <= '1' when se = tar_state else '0';
  neighbors(4) <= '1' when s  = tar_state else '0';
  neighbors(5) <= '1' when sw = tar_state else '0';
  neighbors(6) <= '1' when w  = tar_state else '0';
  neighbors(7) <= '1' when nw = tar_state else '0';

  neighbor_count <= f_count_ones_slv(neighbors);

  c_state : process(all)
  begin
    state_d <= state_q;

    if(neighbor_count >= to_integer(unsigned(G_CONFIG))) then
      state_d <= tar_state;
    end if;
  end process c_state;


  s_regs : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        state_q <= G_INIT;

      else

        state_q <= state_d;

      end if;
    end if;
  end process s_regs;

end architecture cca_cell_arch;
