require 'logica/logicaNenLinea'

class ControladorSesion
    @game = nil
    # Identificador del canal para esta sesion
    @session_id = nil
    @partidas = 0

    def initialize(tamFila, tamTablero, n2win, session_id, player_x, player_o)
        @session_id = session_id
        nuevaSesion(tamFila, tamTablero, n2win, player_x, player_o)
    end

    def nuevaSesion(tamFila, tamTablero, n2win, player_x, player_o)
        @game = LogicaNenLinea.new(tamTablero, tamFila, n2win, player_x, player_o)
        # Respuesta de verificacion al usuario
        ActionCable.server.broadcast "sesion_channel_#{@session_id}" , gameState: @game.gameState,
                                          action: 'Nueva Partida',
                                          tamTablero: tamTablero,
                                          tamFila: tamFila,
                                          n2win: n2win,
                                          status: 'SUCCESS'
    end

    def mover(columna)
        _fila, _columna = @game.play(columna)
        # Respuesta a los jugadores
        ActionCable.server.broadcast "sesion_channel_#{@session_id}", {
            action: "Mover",
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