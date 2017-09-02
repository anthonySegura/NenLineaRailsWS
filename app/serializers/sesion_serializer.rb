class SesionSerializer < ActiveModel::Serializer
  attributes :id, :n_partidas, :n2win, :tiempo_jugada, :tam_tablero
end
