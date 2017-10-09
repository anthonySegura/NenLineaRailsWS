# lib/logica
require 'logica/logicaNenLinea'
# lib/jugadorAutomatico
require 'jugadorAutomatico/randomPlayer'
require 'jugadorAutomatico/defensivePlayer'
# models/categorias
require 'categorias'

##
# Controlador de sesiones
# Esta clase enlaza a dos jugadores con la misma logica del juego
# Transmite los resultados de los movimientos a travez de actioncable

class ControladorSesion
		# Los jugadores se identifican por el nickname
		attr_accessor :player_x, :player_o
		# Lógica del juego, valida las jugadas y controla los turnos
		@game = nil # Identificador del canal para esta sesion, tambien es el id de la sesion en la base de datos
		@session_id = nil
		@partidas = 0


    def initialize(tamFila, tamTablero, n2win, session_id, player_x, **iaOptions)
        @session_id = session_id
        @player_x = player_x
        @player_o = nil
        @tamTablero = tamTablero
        @tamFila = tamFila
        @n2win = n2win
        @session =  Sesion.find(session_id)
        @partidas = @session.n_partidas

        if iaOptions[:ia]
            @player_o = 'CPU'
        end
        # Se inicializa la logica del juego
        nuevaSesion(tamFila, tamTablero, n2win, player_x)
    end

    def nuevaSesion(tamFila, tamTablero, n2win, player_x)
	     ##
	     # Inicializa la logica del juego para la sesion
        @game = LogicaNenLinea.new((tamTablero * tamTablero), tamFila, n2win)
    end

    def iniciarSesion
        ##
        # Se ejecuta una vez que la sesion tenga a los dos jugadores
        # Inicia la partida
        sesion = Sesion.find(@session_id)
        @game.player_o = @player_o
        @game.player_x = player_x
        sesion.estado = 'Jugando'
        sesion.save
        @game.startGame
        # Respuesta de verificacion al usuario creador
        # TODO: pasar a un job en caso que querer notificar a ambos jugadores
        ActionCable.
          server.
          broadcast "sesion_channel_#{@session_id}" ,
                    game_state: @game.gameState,
                    action: 'Nueva Partida',
                    tamTablero: @tamTablero * @tamTablero,
                    tamFila: @tamFila,
                    n2win: @n2win,
                    status: 'SUCCESS',
                    turno: @player_x,
                    rival: @player_o
    end

    def iniciarSesionIA
	      @game.player_o = @player_o
        @game.player_x = @player_x
        
        @game.startGame
        
        SessionAutomaticaJob.perform_later(@session_id, 'Nueva Partida', @player_o, @player_x)
    end

    def mover(columna)
	      ##
	      # Inicializa la logica del juego para esta sesion
        _fila, _columna = @game.play(columna)
        # Respuesta a los jugadores
        transmitirJugada(@game, _fila, _columna)
	      if @game.gameState != 'Playing'
					@partidas -= 1
		      asignarPuntos(@player_x, player_o, @game.gameState)
		      sleep(4)
		      nuevaSesion(@tamFila, @tamTablero, @n2win, @player_x)
		      @game.player_x = @player_x
		      @game.player_o = @player_o
		      if @partidas > 0
			      ActionCable.
				      server.
				      broadcast "sesion_channel_#{@session_id}",
				                action: "Restart",
				                won: @game.gameState
			      @game.startGame
			      ActionCable.
				      server.
				      broadcast "sesion_channel_#{@session_id}" ,
				                game_state: @game.gameState,
				                action: 'Nueva Partida',
				                tamTablero: @tamTablero * @tamTablero,
				                tamFila: @tamFila,
				                n2win: @n2win,
				                status: 'SUCCESS',
				                turno: @player_x,
				                player_x: @player_x,
				                player_o: @player_o
		      else
			      ActionCable
			        .server
			        .broadcast "sesion_channel_#{@session_id}",
			                   action: 'Game Over'
			      Categorias.new.calcularRanking
		      end
	       end
    end

    def moverIA(columna)
        ##
        # El jugador automático es tratado como otro jugador normal
        # Primero se procesa la jugada del cliente y se transmite el resultado
        # Si no hay cambios en el estado del juego se le pasa al jugador automático el tablero para que realice una jugada
        # Se procesa el movimiento del jugador automático y se transmite el resultado al cliente
	    _fila, _columna = @game.play(columna)
	    # Transmitir jugada usuario
	    transmitirJugada(@game, _fila, _columna)
	    if @game.gameState == 'Playing'
		    # Jugada de la maquina
		    iaColumn = DefensivePlayer.new(@game.gameTable ,@tamFila, columna).mover
		    filaM, columnaM = @game.play(iaColumn)
		    # Transmitir jugada maquina
		    transmitirJugada(@game, filaM, columnaM)
	    end
    end

    def transmitirJugada(game, fila, columna)
        ##
        # Transmite el resultado del movimiento a ambos jugadores por medio del canal
        # Resultado: {action: identificador de la respuesta, necesario para el cliente, game_state: estado del juego despues de la jugada,
        # fichas_ganadoras: arreglo con la posicion en formato de arreglo de las fichas ganadoras, turno: nickname del jugador, fila: fila en donde quedo
        # la ficha colocada, columna: columna en donde quedo la ficha colocada}
        ActionCable.
            server.
            broadcast "sesion_channel_#{@session_id}",
                        action: "Mover",
                        game_state: game.gameState,
                        fichas_ganadoras: game.winnerSteps,
                        movimientos: game.performedSteps,
                        turno: game.playerTurn,
                        fila: fila,
                        columna: columna
    end

		def calcularPuntaje(pts_nuestros, pts_adversario)
			pts_nuestros = (pts_nuestros <= 0) ? 10 : pts_nuestros
			pts_adversario = (pts_adversario <= 0) ? 10 : pts_adversario
			score = -Math.log(1 - (1 / (1 + Math.exp(-(pts_adversario / pts_nuestros)))))
			return (score.infinite?) ? 100 : score * 10
		end

	  def asignarPuntos(jugador1, jugador2, ganador)
		  j1 = User.find_by_name(jugador1)
		  j2 = User.find_by_name(jugador2)

		  if ganador == jugador1
			  j1.puntuacion += calcularPuntaje(j1.puntuacion, j2.puntuacion)
			  j1.save

		  elsif ganador == jugador2
			  j2.puntuacion += calcularPuntaje(j2.puntuacion, j1.puntuacion)
			  j2.save

		  else
			  j1.puntuacion += 1
			  j2.puntuacion += 1
			  j1.save
			  j2.save
		  end
	  end

end