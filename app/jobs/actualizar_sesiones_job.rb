class ActualizarSesionesJob < ApplicationJob

	def perform
		ActionCable.
			server.
			broadcast "sesiones_en_espera_channel",
			           sesiones: Sesion.where(estado: 'esperando')
				                         .joins(:user)
				                         .select(:n_partidas, :tam_tablero, :tiempo_espera, :n2win, :tipo, :nickname, :categoria, :id)
	end
end