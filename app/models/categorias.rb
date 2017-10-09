class Categorias

	def calcularRanking

		@users = User.all
		@users.each do |user|
			inferiores = 0
			total = @users.length
			@users.each do |rival|
				if user.puntuacion > rival.puntuacion
					inferiores += 1
				end
			end

			topPercent = (inferiores / total) * 100;

			if topPercent >= 90
				user.categoria = 1
			elsif topPercent >= 50
				user.categoria = 2
			else
				user.categoria = 3
			end
			user.save
		end
	end

end