Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # Rutas del controlador logica
    # Muestra los endpoints del controlador logica
    get '/logica' => 'logica#index'
    # Iniciar juego
    post '/logica/new/:tam/:n_to_win' => 'logica#newGame'
    # Mover ficha
    get '/logica/mover/:columna' => 'logica#mover'

end
