class SesionesEnEsperaChannel < ApplicationCable::Channel
	def subscribed
		stream_from "sesiones_en_espera_channel"
		ActualizarSesionesJob.perform_later
	end

	def unsubscribed

	end

end