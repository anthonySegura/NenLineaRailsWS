require 'controladorSesion'

class SesionChannel < ApplicationCable::Channel

  # Controlador de la sesion
  @controlador
  @session_id

  def verificarTipoSesion(params)
    case params[:command]
      when 'new'
        user = User.find_by_name(params[:user_id])
        sesion = user.sesions.create(n_partidas: 1, tam_tablero: 8, tiempo_espera: 120, n2win: 4, tipo: 'pvp', estado: 'esperando')
        sesion.save
        return sesion.id

      when 'join'
        sesion = Sesion.find(params[:sesion_id])
        return sesion.id

      when 'restart'
        puts('Falta hacerla xd')
      else
        return -1
    end
  end

  def subscribed
    @session_id = verificarTipoSesion(params)
    stream_from "sesion_channel_#{@session_id}"
  end

  def unsubscribed;  end



  # Crea una nueva sesion en la BD
  def crearSesion(opts)
      puts('CREAR SESION')
      @controlador = ControladorSesion.new(
          opts.fetch('tamFila'),
          opts.fetch('tamTablero'),
          opts.fetch('n2win'),
          @session_id
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

  def pausar(opts)

  end

end