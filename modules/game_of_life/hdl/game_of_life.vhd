library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;

entity game_of_life is
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
end entity game_of_life;

architecture game_of_life_arch of game_of_life is

  component game_of_life_cell is
    generic (
      G_START_ALIVE : std_logic := '0'
    );
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;

      n     : in  std_logic;
      ne    : in  std_logic;
      e     : in  std_logic;
      se    : in  std_logic;
      s     : in  std_logic;
      sw    : in  std_logic;
      w     : in  std_logic;
      nw    : in  std_logic;

      alive : out std_logic
    );
  end component game_of_life_cell;

  signal n  : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal ne : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal e  : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal se : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal s  : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal sw : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal w  : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal nw : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);

begin

  gen_rows : for r in 0 to G_HEIGHT-1 generate
    gen_cols : for c in 0 to G_WIDTH-1 generate

      u_cell : game_of_life_cell
        generic map (
          G_START_ALIVE => G_INIT(r)(c)
        )
        port map (
          clk   => clk,
          rst   => rst,
          n     => n(r)(c),
          ne    => ne(r)(c),
          e     => e(r)(c),
          se    => se(r)(c),
          s     => s(r)(c),
          sw    => sw(r)(c),
          w     => w(r)(c),
          nw    => nw(r)(c),
          alive => alive(r)(c)
      );

      gen_west : if c = 0 generate
        w(r)(c) <= '0';
      else generate
        w(r)(c) <= alive(r)(c-1);
      end generate gen_west;

      gen_east : if c = G_WIDTH-1 generate
        e(r)(c) <= '0';
      else generate
        e(r)(c) <= alive(r)(c+1);
      end generate gen_east;

      gen_north_west : if r = 0 or c = 0 generate
        nw(r)(c) <= '0';
      else generate
        nw(r)(c) <= alive(r-1)(c-1);
      end generate gen_north_west;

      gen_north_east : if r = 0 or c = G_WIDTH-1 generate
        ne(r)(c) <= '0';
      else generate
        ne(r)(c) <= alive(r-1)(c+1);
      end generate gen_north_east;

      gen_south_west : if r = G_HEIGHT-1 or c = 0 generate
        sw(r)(c) <= '0';
      else generate
        sw(r)(c) <= alive(r+1)(c-1);
      end generate gen_south_west;

      gen_south_east : if r = G_HEIGHT-1 or c = G_WIDTH-1 generate
        se(r)(c) <= '0';
      else generate
        se(r)(c) <= alive(r+1)(c+1);
      end generate gen_south_east;

    end generate gen_cols;

    gen_north : if r = 0 generate
      n(r) <= (others => '0');
    else generate
      n(r) <= alive(r-1);
    end generate gen_north;

    gen_south : if r = G_HEIGHT-1 generate
      s(r) <= (others => '0');
    else generate
      s(r) <= alive(r+1);
    end generate gen_south;

  end generate gen_rows;

end architecture game_of_life_arch;
