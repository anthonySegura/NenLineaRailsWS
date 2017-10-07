require 'controladorSesion'

class SesionChannel < ApplicationCable::Channel

  # Diccionario para almacenar los controladores de todas las sesiones
  @@controladores = Hash.new
  # Controlador de sesión para esta conexión
  @controlador
  # Identificador para la sesion
  @session_id

  def verificarTipoSesion(params)
	  ##
	  # Funcion auxiliar para verificar las solicitudes de conexion
	  # El tipo de conexión se envia como parametro con la llave :command
	  # Hay 3 tipos de solicitud:
	  #   * Crear una nueva sesión :command => new
	  #   * Unirse a una sesión creada :command => join
	  #   * Restaurar una sesión pausada :command => restart
	  #   * Para jugar contra la maquina :command => IA
	  # Devuelve el id de la sesión o -1 si no se puede realizar la conexión
    case params[:command]
      # Conexión para el usuario creador
      when 'new'
        # Crea una nueva sesion relacionada con el usuario
        user = User.find_by_name(params[:user_id])
        sesion = user.sesions.create(n_partidas: params[:n_partidas],
                                     tam_tablero: params[:tamFila],
                                     tiempo_espera: 120,
                                     n2win: params[:n2win],
                                     tipo: params[:tipo],
                                     estado: 'esperando'
                                    )
        sesion.save
        nuevaSesion(params, sesion.id)
        return sesion.id

      # Conexión para el usuario invitado
      when 'join'
        sesion = Sesion.find(params[:sesion_id])
        user = User.find_by_name(params[:user])
        if user != nil
          agregarUsuarioASesion(sesion.id, user)
          return sesion.id
        end
        return -1
      # En caso de querer restaurar una sesión.
      # Se trae la sesión desde la base de datos para despues reiniciar el juego con la configuración con la que se pauso
      when 'restart'
        # TODO: agregar logica para reiniciar sesion
        puts('restart')
      # Conexión para jugar contra el jugador automático
      # Se crea un controlador de sesión indicando que el tipo de juego va a ser automático
      when 'IA'
        user = User.find_by_name(params[:user_id])
        sesion = user.sesions.create(n_partidas: params[:n_partidas],
                                     tam_tablero: params[:tamFila],
                                     tiempo_espera: 120,
                                     n2win: params[:n2win],
                                     tipo: params[:tipo],
                                     estado: 'jugando'
        )
        sesion.save
        nuevaSesionIA(params, sesion.id, ia: true, nivel: 'facil')
        return sesion.id
      else
        return -1
    end
  end

  def subscribed
    @session_id = verificarTipoSesion(params)
    stream_from "sesion_channel_#{@session_id}"
    if @session_id == -1
      refuseConnection
    end
  end

  def unsubscribed

  end

  def refuseConnection
    ActionCable.
        server.
        broadcast "sesion_channel_-1", action: 'refused'
  end

  def nuevaSesion(params, session_id)
      puts('CREAR SESION')
      @controlador = ControladorSesion.new(
          params[:tamFila],
          params[:tamFila],
          params[:n2win],
          session_id,
          params[:user_id]
      )
      @@controladores[session_id] = @controlador
  end

  def nuevaSesionIA(params, session_id, **iaOptions)
    puts('CREAR SESION IA')
    @controlador = ControladorSesion.new(
      params[:tamFila],
      params[:tamFila],
      params[:n2win],
      session_id,
      params[:user_id],
      iaOptions
    )
    @controlador.iniciarSesionIA()
  end

  def agregarUsuarioASesion(sesion_id, user)
    @@controladores[sesion_id].player_o = user.name
    @@controladores[sesion_id].iniciarSesion()
    @controlador = @@controladores[sesion_id]
  end


  def mover(opts)
    @controlador = @@controladores[@session_id]
    @controlador.mover(opts.fetch('columna'))
  end

  def moverIA(opts)
    @controlador.moverIA(opts.fetch('columna'))
  end

  def pausarSesion(opts)

  end

  # Envia el mensaje al chat de la sesion
  def enviarMensaje(opts)
    puts('MENSAJE')
    ActionCable.
      server.
      broadcast "sesion_channel_#{@session_id}",
                 action: 'message',
                 message: opts.fetch('message'),
                 send_by: opts.fetch('send_by')
  end

end