# Ya funciona
# Necesario para poder imprimir cada fila del tablero sin saltos de linea
#$stdout.sync = true
require_relative 'coordenada'
# Constantes Globales
# Jugadores
VACIO = '-'
# Estados del juego
PLAYING, X_WINS, O_WINS, TIE = 'Playing', 'X WINS', 'O WINS', 'TIE'

# TODO refactorizar
class LogicaNenLinea
    # Getters para los atributos de lectura
    attr_accessor :player_o, :player_x
    attr_reader :gameState, :gameTable, :winnerSteps, :performedSteps, :playerTurn, :stepsToWin
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
        @player_x
        @player_o
    end

    # Inicializa las estructuras internas de la clase
    def startGame
        # Se llena el arreglo con posiciones vacias
        (@tableSize).times do
            @gameTable.push(VACIO)
        end
        # Inicia el jugador X
        @playerTurn = @player_x
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
        @playerTurn = (@playerTurn == @player_x) ? @player_o : @player_x
    end

    # Convierte un indice de 2D a 1D
    def transformCoordToArrayPosition(row, column)
        return @rowSize * row + column
    end

    def isAvalidCoord(coor)
         if coor.rowPosition >= @rowSize || coor.columnPosition >= @rowSize || coor.rowPosition < 0 || coor.columnPosition < 0
              return false
         else
             return true
         end

    end

    def getDelimitedCoord(origin, whereToGo)
        originalRow = origin.rowPosition
        originalColumn = origin.columnPosition
        goalRow = originalRow
        goalColumn = originalColumn
        stepsLength = 0
        rowLength = @rowSize - 1

        if whereToGo == 'leftUp'
            originalRow -= 1
            originalColumn -= 1
            while originalRow >= 0 && originalColumn >= 0
                if stepsLength == (@stepsToWin - 1)
                    break
                end
                goalRow -= 1
                goalColumn -= 1
                stepsLength += 1
                originalRow -= 1
                originalColumn -= 1
            end
        elsif whereToGo == 'rightUp'
            originalRow -= 1
            originalColumn += 1
            while originalRow >= 0 && originalColumn <= rowLength
                if stepsLength == (@stepsToWin - 1)
                    break
                end
                goalRow -= 1
                goalColumn -= 1
                stepsLength += 1
                originalRow -= 1
                originalColumn += 1
            end
        elsif whereToGo == 'leftDown'
            originalRow += 1
            originalColumn -= 1
            while originalRow <= rowLength && originalColumn >= 0
                if stepsLength == (@stepsToWin - 1)
                    break
                end
                goalRow += 1
                goalColumn -= 1
                stepsLength += 1
                originalRow += 1
                originalColumn -= 1
            end
        elsif whereToGo == 'rightDown'
            originalRow += 1
            originalColumn += 1
            while originalRow <= rowLength && originalColumn <= rowLength
                if stepsLength == (@stepsToWin - 1)
                    break
                end
                goalRow += 1
                goalColumn += 1
                stepsLength += 1
                originalRow += 1
                originalColumn += 1
            end
        end
      return Coordenada.new(goalRow, goalColumn)
    end

    def winnerInLine(initialPosition, finalPosition, player)
        if ! isAvalidCoord(finalPosition)
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

        row = lastPlayed.rowPosition
        column = lastPlayed.columnPosition
        result = ''
        # Verificar las coordenadas a la izquierda de la ultima jugada
        leftLimit = column - (@stepsToWin - 1)
        wellLimit = nil

        if leftLimit < 0
            wellLimit = leftLimit + -1*(leftLimit)
        else
            wellLimit = leftLimit
        end
        col = column
        while col >= wellLimit
            result = verifyWinner(Coordenada.new(row, col))
            col -= 1
            if result != 'no win'
                return result
            end
        end
        # Verifica los puntos a la derecha de la ultima jugada
        rightLimit = column + (@stepsToWin - 1)
        if rightLimit > (@rowSize - 1)
            wellLimit = (@rowSize - 1)
        else
            wellLimit = rightLimit
        end
        col = column
        while col <= wellLimit
            result = verifyWinner(Coordenada.new(row, col))
            if result != 'no win'
                return result
            end
            col += 1
        end
        # Verifica los puntos por debajo de la ultima jugada
        downLimit = row + (@stepsToWin - 1)
        if downLimit > (@rowSize - 1)
            wellLimit = (@rowSize - 1)
        else
            wellLimit = downLimit
        end
        r = row
        while r <= wellLimit
            result = verifyWinner(Coordenada.new(r, column))
            if result != 'no win'
                return result
            end
            r += 1
        end

        # Verificar los puntos diagonales arriba a la izquierda de la ultima jugada
        coord = getDelimitedCoord(lastPlayed, 'leftUp')
        r = coord.rowPosition
        while r <= row
            j = coord.columnPosition
            while j <= column
                result = verifyWinner(Coordenada.new(r, j))
                if result != 'no win'
                    return result
                end
                j += 1
            end
            r += 1
        end
        # Verificar los puntos diagonales arriba a la derecha de la ultima jugada
        coord = getDelimitedCoord(lastPlayed, 'rightUp')
        r = coord.rowPosition
        while r <= row
            j = coord.columnPosition
            while j <= column
                result = verifyWinner(Coordenada.new(r, j))
                if result != 'no win'
                    return result
                end
                j += 1
            end
            r += 1
        end
        # Verificar los puntos diagonales arriba a la derecha de la ultima jugada
        coord = getDelimitedCoord(lastPlayed, 'rightUp')
        r = coord.rowPosition
        while r <= row
            j = coord.columnPosition
            while j <= column
                result = verifyWinner(Coordenada.new(r, j))
                if result != 'no win'
                    return result
                end
                j += 1
            end
            r += 1
        end
        # Verificar los puntos diagonales debajo a la izquierda de la ultima jugada
        coord = getDelimitedCoord(lastPlayed, 'leftDown')
        r = coord.rowPosition
        while r >= row
            j = coord.columnPosition
            while j <= column
                result = verifyWinner(Coordenada.new(r, j))
                if result != 'no win'
                    return result
                end
                j += 1
            end
            r -= 1
        end
        # Verificar los puntos diagonales por debajo a la derecha de la ultima jugada
        coord = getDelimitedCoord(lastPlayed, 'rightDown')
        r = coord.rowPosition
        while r >= row
            j = coord.columnPosition
            while j >= column
                result = verifyWinner(Coordenada.new(r,j))
                if result != 'no win'
                    return result
                end
                j -= 1
            end
            r -= 1
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
                puts('error esta aqui')
                puts('Gano ' + @playerTurn)
                @gameState = (@playerTurn == @player_x) ? @player_x : @player_o
            else
                @gameState = PLAYING
            end
            changeTurn
            return posJugada.rowPosition, posJugada.columnPosition
        rescue Exception => e
            raise e
        end
    end
end



