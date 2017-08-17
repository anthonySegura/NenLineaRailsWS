# Ya funciona
# Necesario para poder imprimir cada fila del tablero sin saltos de linea
#$stdout.sync = true
require_relative 'coordenada'
# Constantes Globales
# Jugadores
PLAYER_X, PLAYER_O, VACIO = 'X', 'O', '-'
# Estados del juego
PLAYING, X_WINS, O_WINS, TIE = 'Playing', 'X WINS', 'O WINS', 'TIE'

# TODO refactorizar
class LogicaNenLinea
    # Getters para los atributos de lectura
    attr_reader :gameState, :gameTable, :winnerSteps, :performedSteps, :playerTurn
    # Constructor de la clase
    def initialize(tableSize = 64, rowSize = 8, stepsToWin = 4)
        @gameTable = []
        @playerTurn
        @performedSteps
        @gameState
        @winnerSteps = []
        @tableSize = tableSize
        @rowSize = rowSize
        @stepsToWin = stepsToWin

        startGame
    end

    # Inicializa las estructuras internas de la clase
    def startGame
        # Se llena el arreglo con posiciones vacias
        @tableSize.times do
            @gameTable.push(VACIO)
        end
        # Inicia el jugador X
        @playerTurn = PLAYER_X
        @performedSteps = 0
        @gameState = PLAYING
        @winnerSteps.clear
    end

    # Recibe la columna del tablero y 'deja caer' la ficha
    # Retorna - coordenada en formato matriz de la posicion en donde quedó la ficha
    def putCard(choosedColumn)
        if choosedColumn < 0 || choosedColumn > @rowSize
            return nil
        end
        row = @rowSize - 1
        while row >= 0 do
            if  @gameTable[@rowSize * row + choosedColumn] == VACIO
                @gameTable[@rowSize * row + choosedColumn] = @playerTurn
                @performedSteps += 1
                return Coordenada.new(row, choosedColumn)
            end
            row -= 1
        end
    end

    def changeTurn
        @playerTurn = (@playerTurn == PLAYER_X) ? PLAYER_O : PLAYER_X
    end

    # Convierte un indice de 2D a 1D
    def transformCoordToArrayPosition(row, column)
        return @rowSize * row + column
    end

    def winnerInLine(initialPosition, finalPosition, player)
        if finalPosition.rowPosition >= @rowSize || finalPosition.columnPosition >= @rowSize || finalPosition.rowPosition < 0 || finalPosition.columnPosition < 0
             return false
         end

        # Si la busqueda es en la misma fila, entonces hay que buscar a la izquirda o a la derecha
        if finalPosition.rowPosition == initialPosition.rowPosition
            if finalPosition.columnPosition > initialPosition.columnPosition
                # Iterar desde la ficha inicial hacia la derecha
                row = initialPosition.rowPosition
                for column in (initialPosition.columnPosition..finalPosition.columnPosition)
                    if @gameTable[transformCoordToArrayPosition(row, column)] != player
                        @winnerSteps.clear
                        return false
                    else
                        @winnerSteps.push(transformCoordToArrayPosition(row, column))
                    end
                end
                return true
            else
                # Iterar hacia la izquierda desde la ficha actual
                row = initialPosition.rowPosition
                column = initialPosition.columnPosition
                while column >= finalPosition.columnPosition
                    if @gameTable[transformCoordToArrayPosition(row, column)] != player
                        @winnerSteps.clear
                        return false
                    else
                        @winnerSteps.push(transformCoordToArrayPosition(row, column))
                    end
                    column -= 1
                end
                return true
            end
        elsif finalPosition.rowPosition != initialPosition.rowPosition && finalPosition.columnPosition == initialPosition.columnPosition
            # Iterar 4 fichas por debajo de la ficha inicial
            column = initialPosition.columnPosition
            for row in (initialPosition.rowPosition..finalPosition.rowPosition)
                if @gameTable[transformCoordToArrayPosition(row, column)] != player
                    @winnerSteps.clear
                    return false
                else
                    @winnerSteps.push(transformCoordToArrayPosition(row, column))
                end
            end
            return true
        else
            # Recorrer las diagonales desde la ficha inicial
            if finalPosition.rowPosition < initialPosition.rowPosition
                if finalPosition.columnPosition < initialPosition.columnPosition
                    row = finalPosition.rowPosition
                    column = finalPosition.columnPosition
                    while row <= initialPosition.rowPosition && column <= initialPosition.columnPosition
                        if @gameTable[transformCoordToArrayPosition(row, column)] != player
                            @winnerSteps.clear
                            return false
                        else
                            @winnerSteps.push(transformCoordToArrayPosition(row, column))
                        end
                        row += 1
                        column += 1
                    end
                    return true
                else
                    row = finalPosition.rowPosition
                    column = finalPosition.columnPosition
                    while row <= initialPosition.rowPosition && column >= initialPosition.columnPosition
                        if @gameTable[transformCoordToArrayPosition(row, column)] != player
                            @winnerSteps.clear
                            return false
                        else
                            @winnerSteps.push(transformCoordToArrayPosition(row, column))
                        end
                        row += 1
                        column -= 1
                    end
                    return true
                end
            else
                # Recorrer las diagonales hacia abajo
                if finalPosition.columnPosition < initialPosition.columnPosition
                    row = finalPosition.rowPosition
                    column = finalPosition.columnPosition
                    while row >= initialPosition.rowPosition && column <= initialPosition.columnPosition
                        if @gameTable[transformCoordToArrayPosition(row, column)] != player
                            @winnerSteps.clear
                            return false
                        else
                            @winnerSteps.push(transformCoordToArrayPosition(row, column))
                        end
                        row -= 1
                        column += 1
                    end
                    return true
                else
                    # La diagonal es hacia abajo a la derecha
                    row = finalPosition.rowPosition
                    column = finalPosition.columnPosition
                    while row >= initialPosition.rowPosition && column >= initialPosition.columnPosition
                        if @gameTable[transformCoordToArrayPosition(row, column)] != player
                            @winnerSteps.clear
                            return false
                        else
                            @winnerSteps.push(transformCoordToArrayPosition(row, column))
                        end
                        row -= 1
                        column -= 1
                    end
                    return true
                end
            end
        end
    end

    def verifyWinner(lastStep)
        steps = @stepsToWin - 1
        # Si a la izquierda de la ultima jugada hay 4 fichas iguales
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition, lastStep.columnPosition - steps), @playerTurn)
            return 'winner left'
        end
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition, lastStep.columnPosition + steps), @playerTurn)
            return 'winner right'
        end
        # Verifica 4 fichas iguales por debajo de la ultima ficha ingresada
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition + steps, lastStep.columnPosition), @playerTurn)
            return 'winner down'
        end
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition - steps, lastStep.columnPosition - steps), @playerTurn)
            return 'winner up left diagonal'
        end
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition - steps, lastStep.columnPosition + steps), @playerTurn)
            return 'winner up right diagonal'
        end
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition + steps, lastStep.columnPosition - steps), @playerTurn)
            return 'winner down left diagonal'
        end
        if winnerInLine(lastStep, Coordenada.new(lastStep.rowPosition + steps, lastStep.columnPosition + steps), @playerTurn)
            return 'winner down right diagonal'
        end

        return 'no win'
    end


    def verifyRow(lastPlayed)
        evaluatedRow = lastPlayed.rowPosition
        initialColumn = @rowSize * evaluatedRow

        for column in (initialColumn...initialColumn + @rowSize)
            if @gameTable[transformCoordToArrayPosition(evaluatedRow, column)] != VACIO
                originalColumn = column - evaluatedRow * @rowSize
                result = verifyWinner(Coordenada.new(evaluatedRow, originalColumn))
                if result != 'no win'
                    return result
                end
            end
        end
        return 'no hay nada'
    end

    def imprimirTablero
        @tableSize.times do |i|
            ficha = (@gameTable[i] == VACIO) ? i : @gameTable[i]
            print(ficha, '       ')
            sleep 0.001
            if (i + 1) % @rowSize == 0
                puts
            end
        end
    end

    # Metodo para realizar cada movimiento (Jugador o Maquina)
    # Recibe la columna del tablero
    def play(column)
        begin
            posJugada = putCard(column)
            if verifyRow(posJugada) != 'no hay nada'
                puts('Gano ' + @playerTurn)
                @gameState = (@playerTurn == PLAYER_X) ? X_WINS : O_WINS
            else
                @gameState = PLAYING
                changeTurn
            end
            return posJugada.rowPosition, posJugada.columnPosition
        rescue
            raise 'La columna indicada no coincide con el tamaño del tablero'
        end
    end
end



