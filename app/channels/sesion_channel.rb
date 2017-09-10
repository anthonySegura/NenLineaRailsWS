require 'controladorSesion'

class SesionChannel < ApplicationCable::Channel

  @controlador = nil
  @session_id

  def subscribed
    @session_id = params[:user_id]
    stream_from "sesion_channel_#{@session_id}"
  end

  def unsubscribed;  end

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

  def getn2Win(opts)
    puts(opts.fetch('id'))
    @controlador.getn2win()
  end

  def mover(opts)

  end

  def pausar(opts)

  end

end