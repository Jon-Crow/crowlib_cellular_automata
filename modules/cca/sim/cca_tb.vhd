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

  function f_state_to_color (
    state : std_logic_vector(3 downto 0)
  ) return t_color is
  begin
    case(state) is
      when x"0"   => return (r => x"FF", g => x"00", b => x"00", a => x"FF"); -- Red
      when x"1"   => return (r => x"FF", g => x"60", b => x"00", a => x"FF");
      when x"2"   => return (r => x"FF", g => x"BF", b => x"00", a => x"FF");
      when x"3"   => return (r => x"DF", g => x"FF", b => x"00", a => x"FF");
      when x"4"   => return (r => x"80", g => x"FF", b => x"00", a => x"FF");
      when x"5"   => return (r => x"20", g => x"FF", b => x"00", a => x"FF");
      when x"6"   => return (r => x"00", g => x"FF", b => x"40", a => x"FF");
      when x"7"   => return (r => x"00", g => x"FF", b => x"9F", a => x"FF");
      when x"8"   => return (r => x"00", g => x"FF", b => x"FF", a => x"FF"); -- Cyan
      when x"9"   => return (r => x"00", g => x"9F", b => x"FF", a => x"FF");
      when x"A"   => return (r => x"00", g => x"40", b => x"FF", a => x"FF");
      when x"B"   => return (r => x"20", g => x"00", b => x"FF", a => x"FF");
      when x"C"   => return (r => x"80", g => x"00", b => x"FF", a => x"FF");
      when x"D"   => return (r => x"DF", g => x"00", b => x"FF", a => x"FF");
      when x"E"   => return (r => x"FF", g => x"00", b => x"BF", a => x"FF");
      when x"F"   => return (r => x"FF", g => x"00", b => x"60", a => x"FF");
      when others => return K_COLOR_BLACK;
    end case;
  end function f_state_to_color;

  constant K_INIT : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(3 downto 0) := f_rand_init(1234);

  signal clk    : std_logic;
  signal rst    : std_logic;

  signal states : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(3 downto 0);

  signal px     : t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1);

begin

  gen_px_row : for r in 0 to G_HEIGHT-1 generate
    gen_px_col : for c in 0 to G_WIDTH-1 generate
      px(r)(c) <= f_state_to_color(states(r)(c));
    end generate gen_px_col;
  end generate gen_px_row;

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

  u_display : entity crowlib.sim_display
    generic map (
      G_WIDTH  => G_WIDTH,
      G_HEIGHT => G_HEIGHT
    )
    port map (
      clk    => clk,
      rst    => rst,

      px     => px,
      update => '1'
  );

end architecture cca_tb_arch;
