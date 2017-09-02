class CreateSesions < ActiveRecord::Migration[5.1]
  def change
    create_table :sesions do |t|
      t.integer :n_partidas
      t.integer :n2win
      t.integer :tiempo_jugada
      t.integer :tam_tablero

      t.timestamps
    end
  end
end
