Rails.application.routes.draw do

  resources :sesions
  get 'user/index'

  get 'user/show'

  post 'user/create'

  post 'user/update'

  post 'user/delete'

    # Rutas del controlador logica
    # Muestra los endpoints del controlador logica
    get '/logica' => 'logica#index'

    # Mover ficha
    get '/logica/mover/:columna' => 'logica#mover'

    # TODO agregar parametro para crear partida contra el jugador automatico
    # Iniciar juego, GET por mientras, se deberia pasar a POST o algo asi
    get '/logica/new/:tamF/:n2w' => 'logica#newGame'

end
