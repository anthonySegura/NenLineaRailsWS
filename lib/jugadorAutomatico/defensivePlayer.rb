class DefensivePlayer

	def initialize(tablero, filas, jugadaAnterior)
		@tablero = tablero
		@filas = filas
		@jugadaAnterior = jugadaAnterior
		@tamFila = filas
	end

	def getValidColumns
		cols = []
		@filas.times do |i|
			if @tablero[i] == '-'
				cols.push(i)
			end
		end
		return cols
	end

	def getNearColumns
			cols = []
			if @jugadaAnterior > 0 && @jugadaAnterior + 1 < @tamFila
				(@jugadaAnterior - 1..@jugadaAnterior + 1).each do |pos|
					if @tablero[pos] == '-'
						cols.push(pos)
					end
				end
			elsif @jugadaAnterior == 0
				(@jugadaAnterior..@jugadaAnterior + 1).each do |pos|
					if @tablero[pos] == '-'
						cols.push(pos)
					end
				end
			elsif @jugadaAnterior + 1 >= @tamFila
				(@jugadaAnterior - 1..@jugadaAnterior).each do |pos|
					if @tablero[pos] == '-'
						cols.push(pos)
					end
				end
			end
			return cols
	end

	def mover
		columnasCercanas = getNearColumns
		columnasValidas = getValidColumns
		if columnasCercanas.length > 0
			return columnasCercanas[rand(columnasCercanas.length)]
		else
			return columnasValidas[rand(columnasValidas.length)]
		end
	end

end