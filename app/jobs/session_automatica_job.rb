class SessionAutomaticaJob < ApplicationJob

	def perform(sesion_id, action, rival, turno)
		ActionCable.
				server.
				broadcast "sesion_channel_#{sesion_id}",
				           game_state: 'Playing',
				           action: action,
				           rival: rival,
				           turno: turno

	end
end