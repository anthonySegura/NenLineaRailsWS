class ActualizarSesionesJob < ApplicationJob

	def perform
		query = ActiveRecord::Base.connection.execute("select * from sesions inner join users
				on users.id = sesions.user_id
						where sesions.estado = 'esperando'")
		ActionCable.
			server.
			broadcast "sesiones_en_espera_channel",
			           sesiones: query
	end
end