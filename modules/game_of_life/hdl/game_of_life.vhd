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
    constant RN : natural := (r - 1) mod G_HEIGHT;
    constant RS : natural := (r + 1) mod G_HEIGHT;
  begin
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

    end generate gen_cols;

    n(r)  <= alive(RN);
    ne(r) <= alive(RN)(0) & alive(RN)(G_WIDTH-1 downto 1);
    e(r)  <= alive(r)(0)  & alive(r)(G_WIDTH-1 downto 1);
    se(r) <= alive(RS)(0) & alive(RS)(G_WIDTH-1 downto 1);
    s(r)  <= alive(RS);
    sw(r) <= alive(RS)(G_WIDTH-2 downto 0) & alive(RS)(G_WIDTH-1);
    w(r)  <= alive(r)(G_WIDTH-2 downto 0)  & alive(r)(G_WIDTH-1);
    nw(r) <= alive(RN)(G_WIDTH-2 downto 0) & alive(RN)(G_WIDTH-1);

  end generate gen_rows;

end architecture game_of_life_arch;
