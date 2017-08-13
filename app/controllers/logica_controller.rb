require 'logica/logicaNenLinea'

# Controlador de la logica del juego
# Inicia un nuevo juego, realiza los movimientos y retorna el estado del juego
class LogicaController < ApplicationController
    # Logica del juego
    @@game = LogicaNenLinea.new

    # Muestra los endpoints de este controlador
    def index
        render json: {status: 'SUCCESS',
                      endpoints: ["get /logica/mover/:columna",
                                  "post /logica/new/:tamF/:n2w | Tamaño de la fila, seguidas para ganar "]
                     }, status: :ok
    end

    # Realiza el movimiento en la columna indicada y devuelve el estado del juego
    def mover
        begin
            columna = Integer(params[:columna])
            @@game.play(columna)
            render json: {status: 'SUCCESS','game_state'=> @@game.gameState,
                          'fichas_ganadoras' => @@game.winnerSteps,
                          'movimientos' => @@game.performedSteps}, status: :ok
        rescue Exception => e
            puts(e)
            render json: {status: 'ERROR', message: 'parametros invalidos'}, status: :error
        end
    end

    def newGame
        begin
            tamFila = Integer(params[:tamF])
            tamTablero = tamFila * tamFila
            n2Win = Integer(params[:n2w])

            @@game = LogicaNenLinea.new(tamTablero, tamFila, n2Win)
            render json: {status: 'SUCCESS', 'game_state' => @@game.gameState, message: 'Nueva Partida',
                          tamTablero: tamTablero, tamFila: tamFila, seguidas_para_ganar: n2Win}, status: :ok
        rescue Exception => e
            puts(e)
            render json: {status: 'ERROR', message: 'parametros invalidos'}, status: :error
        end
    end
end
