require 'logica/logicaNenLinea'

# Controlador de la logica del juego
# Inicia un nuevo juego, realiza los movimientos y retorna el estado del juego
class LogicaController < ApplicationController

    # Inicializa los atributos de la clase
    def initialize
         @game = LogicaNenLinea.new
    end

    # Muestra los endpoints de este controlador
    def index
        render json: {status: 'SUCCESS',
                      endpoints: ["get /logica/mover/:columna",
                                  "post /logica/new/:tam"]
                     }, status: :ok
    end

    # Realiza el movimiento en la columna indicada y devuelve el estado del juego
    def mover
        begin
            columna = Integer(params[:columna])
            @game.play(columna)
            render json: {status: 'SUCCESS','game_state'=> @game.gameState,
                          'fichas_ganadoras' => @game.winnerSteps}, status: :ok
        rescue
            render json: {status: 'ERROR', message: 'parametros invalidos'}, status: :error
        end
    end

    def newGame
        begin
            tamFila = Integer(params[:tam])
            n2win = Integer(params[:n_to_win])
            @game.new(tamFila * tamFila, tamFila, n2win)

            render json: {status: 'SUCCESS', 'game_state' => @game.gameState, message: 'Nueva Partida'}, status: :ok
        rescue

        end
    end
end
