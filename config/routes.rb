Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # Rutas del controlador logica

    # Muestra los endpoints del controlador logica
    get '/logica' => 'logica#index'

    # Mover ficha
    get '/logica/mover/:columna' => 'logica#mover'

    # Iniciar juego, GET por mientras, se deberia pasar a POST o algo asi
    get '/logica/new/:tamF/:n2w' => 'logica#newGame'

end
