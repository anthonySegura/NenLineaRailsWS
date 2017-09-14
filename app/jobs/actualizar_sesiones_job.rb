class ActualizarSesionesJob < ApplicationJob

	def perform
		query = ActiveRecord::Base.connection.execute("select distinct * from sesions inner join users
				on users.id = sesions.user_id
						where sesions.estado = 'esperando'")
		ActionCable.
			server.
			broadcast "sesiones_en_espera_channel",
			           sesiones: Sesion.where(estado: 'esperando')
	end
end