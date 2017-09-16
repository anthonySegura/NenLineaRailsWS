require 'controladorSesion'

class SesionChannel < ApplicationCable::Channel

  # Controladores de todas las sesiones
  @@controladores = Hash.new
  @controlador
  @session_id

  # Funcion auxiliar para verificar las solicitudes de conexion
  # El tipo de conexión se envia como parametro con la llave :command
  # Hay 3 tipos de solicitud:
  #   * Crear una nueva sesión :command => new
  #   * Unirse a una sesión creada :command => join
  #   * Restaurar una sesión pausada :command => restart
  # Devuelve el id de la sesión o -1 si no se puede realizar la conexión
  def verificarTipoSesion(params)
    case params[:command]
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

      when 'join'
        # FIXME: agregar el usuario al controlador de la sesion en espera, Verificar la sesion antes
        sesion = Sesion.find(params[:sesion_id])
        user = User.find_by_name(params[:user])
        if user != nil
          @@controladores[sesion.id].player_o = user.name
          @@controladores[sesion.id].iniciaPartida()
          @controlador = @@controladores[sesion.id]
          return sesion.id
        end
        puts('USUARIO NO IDENTIFICADO')
        return -1
      when 'restart'
        # TODO: agregar logica para reiniciar sesion
        puts('restart')
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

  def unirse

  end

  def mover(opts)
    @controlador = @@controladores[@session_id]
    @controlador.mover(opts.fetch('columna'))
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