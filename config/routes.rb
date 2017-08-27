Rails.application.routes.draw do

  resources :users
    # Rutas del controlador de los usuarios
    get 'user/index'

    get 'user/show'

    get 'user/new'

    get 'user/create'

    get 'user/edit'

    get 'user/update'

    get 'user/destroy'

    # Rutas del controlador logica
    # Muestra los endpoints del controlador logica
    get '/logica' => 'logica#index'

    # Mover ficha
    get '/logica/mover/:columna' => 'logica#mover'

    # TODO agregar parametro para crear partida contra el jugador automatico
    # Iniciar juego, GET por mientras, se deberia pasar a POST o algo asi
    get '/logica/new/:tamF/:n2w' => 'logica#newGame'

end
