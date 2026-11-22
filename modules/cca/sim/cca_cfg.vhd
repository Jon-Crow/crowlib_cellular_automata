
configuration cca_cfg of cca_tb is
  for cca_tb_arch
    for all : cellular_automata_grid
      use entity crowlib.cellular_automata_grid(cellular_automata_grid_arch);
      for cellular_automata_grid_arch
        for gen_rows
          for gen_cols
            for all : cellular_automata_cell
              use entity work.cca_cell;
            end for;
          end for;
        end for;
      end for;
    end for;
  end for;
end configuration cca_cfg;
