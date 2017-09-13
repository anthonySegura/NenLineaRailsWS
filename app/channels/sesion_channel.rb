require 'controladorSesion'

class SesionChannel < ApplicationCable::Channel

  # Controlador de la sesion
  @controlador = nil
  @session_id = nil

  private
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
        # FIXME: obtener los parametros de la peticion y crear el controlador desde aqui
        sesion = user.sesions.create(n_partidas: 1, tam_tablero: 8, tiempo_espera: 120, n2win: 4, tipo: 'pvp', estado: 'esperando')
        sesion.save
        return sesion.id

      when 'join'
        # FIXME: agregar el usuario al controlador de la sesion en espera, Verificar la sesion antes
        sesion = Sesion.find(params[:sesion_id])
        return sesion.id

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
  end

  def unsubscribed;  end

  def nuevaSesion(opts)
      puts('CREAR SESION')
      @controlador = ControladorSesion.new(
          opts.fetch('tamFila'),
          opts.fetch('tamTablero'),
          opts.fetch('n2win'),
          @session_id,
          'X',
          'O'
      )
  end

  def unirse

  end

  # TODO: borrar despues
  def getn2Win(opts)
    puts(opts.fetch('id'))
    @controlador.getn2win()
  end

  def mover(opts)

  end

  def pausarSesion(opts)

  end

  # Envia el mensaje al chat de la sesion
  def enviarMensaje(opts)
    ActionCable.
      server.
      broadcast "sesion_channel_#{@session_id}",
                 message: opts.fetch('message')
  end

end