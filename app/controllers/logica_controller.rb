require 'logica/logicaNenLinea'

# Controlador de la logica del juego
# Inicia un nuevo juego, realiza los movimientos y retorna el estado del juego
class LogicaController < ApplicationController
    # Juego por defecto
    @@game = LogicaNenLinea.new

    # Muestra los endpoints de este controlador
    def index
        render json: {status: 'SUCCESS',
                      endpoints: ["get /logica/mover/:columna",
                                  "get /logica/new/:tamF/:n2w | Tamaño de la fila, seguidas para ganar | GET por mientras, despues se cambia"]
                     }, status: :ok
    end

    # Realiza el movimiento en la columna indicada y devuelve el estado del juego
    def mover
        begin
            columna = Integer(params[:columna])
            @@game.play(columna)
            render json: {status: 'SUCCESS','game_state' => @@game.gameState,
                          'fichas_ganadoras' => @@game.winnerSteps,
                          'movimientos' => @@game.performedSteps,
                          'turno' => @@game.playerTurn}, status: :ok
        rescue Exception => e
            render json: {status: 'ERROR', 'message' => e}, status: :error
        end
    end

    # Crea una nueva partida del juego TODO agregar opcion para partida contra el jugador automatico
    def newGame
        begin
            tamFila = Integer(params[:tamF])
            tamTablero = tamFila * tamFila
            n2Win = Integer(params[:n2w])

            # Se crea una nueva instancia del juego personalizada
            @@game = LogicaNenLinea.new(tamTablero, tamFila, n2Win)
            render json: {status: 'SUCCESS', 'game_state' => @@game.gameState, message: 'Nueva Partida',
                          tamTablero: tamTablero, tamFila: tamFila, seguidas_para_ganar: n2Win}, status: :ok
        rescue Exception => e
            render json: {status: 'ERROR', 'message' => e}, status: :error
        end
    end
end
