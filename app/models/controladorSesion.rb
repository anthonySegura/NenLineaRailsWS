require 'logica/logicaNenLinea'
require_relative '../../app/jobs/nueva_sesion_job'

class ControladorSesion

    @game = nil
    @session_id

    def initialize(tamFila, tamTablero, n2win, session_id)
        @session_id = session_id
        nuevaSesion(tamFila, tamTablero, n2win)
    end

    def nuevaSesion(tamFila, tamTablero, n2win)
        @game = LogicaNenLinea.new(tamTablero, tamFila, n2win)

        ActionCable.server.broadcast "sesion_channel_#{@session_id}" , gameState: @game.gameState,
                                          status: 'Nueva Partida',
                                          tamTablero: tamTablero,
                                          tamFila: tamFila,
                                          n2win: n2win,
                                          status: 'SUCCESS'
    end

    def mover(columna)
        _fila, _columna = @game.play(columna)
        # Respuesta a los jugadores
        ActionCable.server.broadcast "sesion_channel_#{@session_id}", {
            action: "mover",
            game_state: @game.gameState,
            fichas_ganadoras: @game.winnerSteps,
            movimientos: @game.performedSteps,
            turno: @game.playerTurn,
            fila: _fila,
            columna: _columna
            }
    end

    def getn2win
        ActionCable.server.broadcast "sesion_channel_#{@session_id}", n2win: @game.stepsToWin
    end
end