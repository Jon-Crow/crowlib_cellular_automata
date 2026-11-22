library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;
use std.env.finish;

entity game_of_life_tb is
  generic (
    G_SEED : positive := 1
  );
end entity game_of_life_tb;

architecture game_of_life_tb_arch of game_of_life_tb is

  constant K_WIDTH  : natural := 64;
  constant K_HEIGHT : natural := 64;

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
  
  function f_rand_slv (
    width : natural;
    salt  : positive
  ) return std_logic_vector is
    variable seed1 : positive                           := G_SEED;
    variable seed2 : positive                           := salt;
    variable r     : real                               := 0.0;
    variable rand  : std_logic_vector(width-1 downto 0) := (others => '0');
  begin
    for i in 0 to 15 loop
      uniform(seed1, seed2, r);
    end loop;
    
    for i in 0 to width-1 loop
      uniform(seed1, seed2, r);
      rand(i) := '1' when r < 0.5 else '0';
    end loop;
    
    return rand;
  end function f_rand_slv;

  function f_rand_init (
    salt : positive
  ) return t_slv_arr_2d is
    variable val  : t_slv_arr_2d(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0)(0 downto 0) := (others => (others => (others => '0')));
    variable rand : std_logic_vector(K_WIDTH-1 downto 0)                          := (others => '0');
  begin
    for r in 0 to K_HEIGHT-1 loop
      rand := f_rand_slv(K_WIDTH, salt+r);
      for c in 0 to K_WIDTH-1 loop
        val(r)(c)(0) := rand(c);
      end loop;
    end loop;
    return val;
  end function f_rand_init;

  constant K_INIT : t_slv_arr_2d(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0)(0 downto 0) := f_rand_init(123456);

  signal clk   : std_logic;
  signal rst   : std_logic;

  signal alive : t_slv_arr_2d(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0)(0 downto 0);

  signal px    : t_color_arr_2d(0 to K_HEIGHT-1)(0 to K_WIDTH-1);

begin

  gen_px_row : for r in 0 to K_HEIGHT-1 generate
    gen_px_col : for c in 0 to K_WIDTH-1 generate
      px(r)(c) <= K_COLOR_BLUE when alive(r)(c)(0) = '1' else K_COLOR_BLACK;
    end generate gen_px_col;
  end generate gen_px_row;

  process
  begin
    for i in 0 to 999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

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
      G_WIDTH        => K_WIDTH,
      G_HEIGHT       => K_HEIGHT,
      G_STATE_WIDTH  => 1,
      G_INIT         => K_INIT,
      G_CONFIG_WIDTH => 1,
      G_CONFIG       => (others => '0')
    )
    port map (
      clk    => clk,
      rst    => rst,

      states => alive
  );

  u_display : entity crowlib.sim_display
    generic map (
      G_WIDTH  => K_WIDTH,
      G_HEIGHT => K_HEIGHT
    )
    port map (
      clk    => clk,
      rst    => rst,

      px     => px,
      update => '1'
    );

end architecture game_of_life_tb_arch;
