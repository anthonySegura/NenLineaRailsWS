
class RandomPlayer

	def initialize(tablero, filas)
		@tablero = tablero
		@filas = filas
	end

	# Verifica si el tope de cada columna esta disponible para dejar caer una ficha
	def getValidColumns
		cols = []
		@filas.times do |i|
			if @tablero[i] == '-'
				cols.push(i)
			end
		end
		return cols
	end

	def mover
		columnasValidas = getValidColumns
		return columnasValidas[rand(columnasValidas.length)]
	end

end