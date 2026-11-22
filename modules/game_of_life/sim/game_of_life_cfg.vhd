
configuration game_of_life_cfg of game_of_life_tb is
  for game_of_life_tb_arch
    for all : cellular_automata_grid
      use entity crowlib.cellular_automata_grid(cellular_automata_grid_arch);
      for cellular_automata_grid_arch
        for gen_rows
          for gen_cols
            for all : cellular_automata_cell
              use entity work.game_of_life_cell;
            end for;
          end for;
        end for;
      end for;
    end for;
  end for;
end configuration game_of_life_cfg;
