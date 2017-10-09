Rails.application.routes.draw do

    # Ruta para los websockets
    mount ActionCable.server => '/cable'

    # Rutas para el crud de usuarios
    get 'user/index'

    get 'user/show'

    post 'user/create'

    post 'user/update'

    post 'user/delete'

    # Ruta para consultar el ranking
    get '/ranking' => 'user#ranking'

    # Rutas del controlador logica
    # Muestra los endpoints del controlador logica
    get '/logica' => 'logica#index'

    # Mover ficha
    get '/logica/mover/:columna' => 'logica#mover'

    # Iniciar juego, GET por mientras, se deberia pasar a POST o algo asi
    get '/logica/new/:tamF/:n2w' => 'logica#newGame'

end
