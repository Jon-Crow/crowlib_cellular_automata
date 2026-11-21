library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;
use std.env.finish;

entity sim_display_tb is
end entity sim_display_tb;

architecture sim_display_tb_arch of sim_display_tb is

  constant K_WIDTH  : natural := 256;
  constant K_HEIGHT : natural := 256;

  signal clk    : std_logic := '0';
  signal rst    : std_logic := '1';

  signal px     : t_slv_arr(0 to K_HEIGHT-1)(K_WIDTH-1 downto 0) := (others => (others => '0'));
  signal update : std_logic                                      := '0';

begin

  process
  begin
    for i in 0 to 999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

  process
  begin
    update <= '1';

    for i in 0 to K_HEIGHT-1 loop
      if(i mod 2 = 0) then
        px(i) <= (others => '1');
      end if;
    end loop;

    for i in 0 to 99 loop
      for x in 0 to K_HEIGHT-2 loop
        px(i + 1) <= px(i);
      end loop;
      wait until rising_edge(clk);
    end loop;

    update <= '0';
    wait;
  end process;

  u_clks_and_rsts : entity crowlib.clk_and_rst
    generic map (
      G_NUM_CLKS => 1,
      G_CLK_PERS => (0 => 10 ns)
    )
    port map (
      clks(0) => clk,
      rsts(0) => rst
  );

  u_dut : entity crowlib.sim_display
    generic map (
      G_WIDTH  => K_WIDTH,
      G_HEIGHT => K_HEIGHT
    )
    port map (
      clk    => clk,
      rst    => rst,
      px     => px,
      update => update
  );

end architecture sim_display_tb_arch;
