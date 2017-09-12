class ActualizarSesionesJob < ApplicationJob

	def perform
		puts('SESION JOB')
		ActionCable.
			server.
			broadcast "sesiones_en_espera_channel",
			          sesiones: Sesion.where(estado: 'esperando')
	end
end