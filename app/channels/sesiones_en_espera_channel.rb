class SesionesEnEsperaChannel < ApplicationCable::Channel
	def subscribed
		stream_from "sesiones_en_espera_channel"
		ActualizarSesionesJob.perform_later
	end

	def unsubscribed

	end

	def obtenerSesionesEnEspera
		sesiones = Sesion.where(estado: 'esperando')
		ActionCable.server.broadcast "sesiones_en_espera_channel", sesiones: sesiones
	end

end