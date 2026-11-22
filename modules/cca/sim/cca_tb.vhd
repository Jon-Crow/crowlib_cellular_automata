library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;
use std.env.finish;

entity cca_tb is
  generic (
    G_WIDTH  : natural := 64;
    G_HEIGHT : natural := 64;
    G_SEED   : positive := 1
  );
end entity cca_tb;

architecture cca_tb_arch of cca_tb is

  component cellular_automata_grid is
    generic (
      G_WIDTH        : natural                                                                 := 256;
      G_HEIGHT       : natural                                                                 := 256;
      G_STATE_WIDTH  : natural                                                                 := 1;
      G_INIT         : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(G_STATE_WIDTH-1 downto 0) := (others => (others => (others => '0')));
      G_CONFIG_WIDTH : positive                                                                := 1;
      G_CONFIG       : std_logic_vector(G_CONFIG_WIDTH-1 downto 0)                             := (others => '0')
    );
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;

      states : out t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(G_STATE_WIDTH-1 downto 0)
    );
  end component cellular_automata_grid;

  function f_rand_init (
    salt : positive
  ) return t_slv_arr_2d is
    variable val  : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(3 downto 0) := (others => (others => (others => '0')));
  begin
    for r in 0 to G_HEIGHT-1 loop
      for c in 0 to G_WIDTH-1 loop
        val(r)(c) := f_rand_slv(4, G_SEED, salt+(c*G_WIDTH + r));
      end loop;
    end loop;
    return val;
  end function f_rand_init;

  constant K_INIT : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(3 downto 0) := f_rand_init(1234);

  signal clk    : std_logic;
  signal rst    : std_logic;

  signal states : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(3 downto 0);

begin

  u_clk_and_rst : entity crowlib.clk_and_rst
    generic map (
      G_NUM_CLKS => 1,
      G_CLK_PERS => (0 => 5 ns)
    )
    port map (
      clks(0) => clk,
      rsts(0) => rst
  );

  u_dut : cellular_automata_grid
    generic map (
      G_WIDTH        => G_WIDTH,
      G_HEIGHT       => G_HEIGHT,
      G_STATE_WIDTH  => 4,
      G_INIT         => K_INIT,
      G_CONFIG_WIDTH => 4,
      G_CONFIG       => x"1"
    )
    port map (
      clk    => clk,
      rst    => rst,

      states => states
  );

end architecture cca_tb_arch;
