library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
use std.env.finish;

entity game_of_life_tb is
  generic (
    G_SEED : positive := 1
  );
end entity game_of_life_tb;

architecture game_of_life_tb_arch of game_of_life_tb is

  constant K_WIDTH  : natural := 64;
  constant K_HEIGHT : natural := 64;
  
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
  ) return t_slv_arr is
    variable val : t_slv_arr(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0) := (others => (others => '0'));
  begin
    for i in 0 to K_HEIGHT-1 loop
      val(i) := f_rand_slv(K_WIDTH, salt);
    end loop;
    return val;
  end function f_rand_init;

  constant K_INIT : t_slv_arr(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0) := f_rand_init(123456);

  component game_of_life is
    generic (
      G_WIDTH  : positive := 256;
      G_HEIGHT : positive := 256;
      G_INIT   : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0) := (others => (others => '0'))
    );
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;

      alive : out t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0)
    );
  end component game_of_life;

  signal clk   : std_logic;
  signal rst   : std_logic;

  signal alive : t_slv_arr(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0);

begin

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

  u_dut : game_of_life
    generic map (
      G_WIDTH  => K_WIDTH,
      G_HEIGHT => K_HEIGHT,
      G_INIT   => K_INIT
    )
    port map (
      clk   => clk,
      rst   => rst,

      alive => alive
  );

  u_display : entity crowlib.sim_display
    generic map (
      G_WIDTH  => K_WIDTH,
      G_HEIGHT => K_HEIGHT
    )
    port map (
      clk    => clk,
      rst    => rst,

      px     => alive,
      update => '1'
    );

end architecture game_of_life_tb_arch;
