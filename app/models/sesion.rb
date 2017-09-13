class Sesion < ApplicationRecord

	after_commit do
		# Actualiza las sesiones de los clientes despues de cada cambio en un registro
		ActualizarSesionesJob.perform_later
	end

	belongs_to :user
end
