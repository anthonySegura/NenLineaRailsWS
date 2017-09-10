class CreateSesions < ActiveRecord::Migration[5.1]
  def change
    create_table :sesions do |t|
      t.integer :n_partidas
      t.integer :tam_tablero
      t.integer :tiempo_espera
      t.integer :n2win
      t.string :tipo
      t.string :estado
      t.timestamps
    end
  end
end
