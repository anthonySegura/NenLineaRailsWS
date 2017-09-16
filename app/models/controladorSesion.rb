require 'logica/logicaNenLinea'

class ControladorSesion

	  attr_accessor :player_x, :player_o
	  @game = nil
    # Identificador del canal para esta sesion
    @session_id = nil
    @partidas = 0

    def initialize(tamFila, tamTablero, n2win, session_id, player_x)
        @session_id = session_id
        @player_x = player_x
        @player_o
        @tamTablero = tamTablero
        @tamFila = tamFila
        @n2win = n2win
        nuevaSesion(tamFila, tamTablero, n2win, player_x)
    end

    # Crea la logica del juego para esta sesion
    def nuevaSesion(tamFila, tamTablero, n2win, player_x)
        @game = LogicaNenLinea.new((tamTablero * tamTablero), tamFila, n2win)
    end

    # Se ejecuta una vez que la sesion tenga a los dos jugadores
    def iniciaPartida
        sesion = Sesion.find(@session_id)
        @game.player_o = @player_o
        @game.player_x = player_x
        sesion.estado = 'Jugando'
        sesion.save
        @game.startGame
        # Respuesta de verificacion al usuario
        ActionCable.
          server.
          broadcast "sesion_channel_#{@session_id}" ,
                    game_state: @game.gameState,
                    action: 'Nueva Partida',
                    tamTablero: @tamTablero * @tamTablero,
                    tamFila: @tamFila,
                    n2win: @n2win,
                    status: 'SUCCESS',
                    turno: @player_x
    end

    def mover(columna)
        _fila, _columna = @game.play(columna)
        # Respuesta a los jugadores
        ActionCable.
          server.
          broadcast "sesion_channel_#{@session_id}",
                     action: "Mover",
                     game_state: @game.gameState,
                     fichas_ganadoras: @game.winnerSteps,
                     movimientos: @game.performedSteps,
                     turno: @game.playerTurn,
                     fila: _fila,
                     columna: _columna
    end

end