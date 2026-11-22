library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;

entity game_of_life_cell is
  generic (
    G_INIT   : std_logic_vector(0 downto 0) := (others => '0');
    G_CONFIG : std_logic_vector(0 downto 0) := (others => '0')
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;

    n     : in  std_logic_vector(0 downto 0);
    ne    : in  std_logic_vector(0 downto 0);
    e     : in  std_logic_vector(0 downto 0);
    se    : in  std_logic_vector(0 downto 0);
    s     : in  std_logic_vector(0 downto 0);
    sw    : in  std_logic_vector(0 downto 0);
    w     : in  std_logic_vector(0 downto 0);
    nw    : in  std_logic_vector(0 downto 0);

    state : out std_logic_vector(0 downto 0)
  );
end entity game_of_life_cell;

architecture game_of_life_cell_arch of game_of_life_cell is

  constant K_NEIGHBOR_COUNT_WIDTH : natural := natural(ceil(log2(real(9))));

  subtype t_neighbor_count is unsigned(K_NEIGHBOR_COUNT_WIDTH-1 downto 0);

  signal neighbors      : std_logic_vector(7 downto 0);
  signal neighbor_count : t_neighbor_count;

  signal alive_d   : std_logic;
  signal alive_q   : std_logic;

begin

  state(0) <= alive_q;

  neighbor_count <= to_unsigned(f_count_ones_slv(neighbors), K_NEIGHBOR_COUNT_WIDTH);
  neighbors      <= n(0)  &
                    ne(0) &
                    e(0)  &
                    se(0) &
                    s(0)  &
                    sw(0) &
                    w(0)  &
                    nw(0);

  c_alive : process(all)
  begin
    alive_d <= alive_q;

    if(alive_q = '1') then
      if(neighbor_count < 2 or neighbor_count > 3) then
        alive_d <= '0';
      end if;
    else
      if(neighbor_count = 3) then
        alive_d <= '1';
      end if;
    end if;
  end process c_alive;

  s_regs : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        alive_q <= G_INIT(0);

      else

        alive_q <= alive_d;

      end if;
    end if;
  end process s_regs;

end architecture game_of_life_cell_arch;
