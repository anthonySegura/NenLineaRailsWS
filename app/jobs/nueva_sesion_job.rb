class NuevaSessionJob < ApplicationJob
	queue_as :default

	def perform(gameState, message, tamTablero, tamFila, n2win, status)
		puts('PERFORM')
		ActionCable
			.server
			.broadcast('sesion_channel_#{}',
			           game_state: gameState,
			           message: message,
			           tamTablero: tamTablero,
			           tamFila: tamFila,
			           seguidas_para_ganar: n2win,
			           status: status
			)
	end
end