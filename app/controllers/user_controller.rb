class UserController < ApplicationController

  # Devuelve todos los usuarios dentro de la base
  def index
    @users = User.all
    render :json => @users
  end

  # Registra un nuevo usuario
  # No se pueden repetir nickname ni email
  def create
      @user = User.new({:name => params[:name],
                       :email => params[:email],
                       :nickname => params[:nickname],
                       :password => params[:password],
                       :puntuacion => params[:puntuacion],
                       :categoria => params[:categoria]}
                      )
      if @user.save
        render :json => @user
      else
        render :json => {:status => :error, :message => 'Datos invalidos no se pueden repetir nickname ni email'}
      end

  end

  # Busca usuarios por el email
  def show
    begin
      @user = User.where(email: params[:email])
      render :json => @user
    rescue Exception => e
      render :json => e
    end
  end

  # Actualiza los datos de un usuario
  def update
    # Busca al usuario por el email
    @user = User.where(email: params[:email])
    valid_params = ['name', 'nickname', 'password', 'puntuacion', 'categoria']
    update_params = {}
    # Se agregan los atributos para actualizar
    params.each do |k,v|
      if valid_params.include? k
        update_params[k] = v
      end
    end
    if @user.update_all(update_params)
      render :json => {:status => :ok, :message => 'Usuario actualizado'}
    else
      render :json => {:status => :error, :message => 'Error al actualizar'}
    end
  end

  # Elimina a un usuario de la base de datos
  # Se busca al usuario por el email
  def delete
    @user = User.where(email: params[:email])
    if User.delete(@user)
      render :json => {:status => :ok, :message => 'Usuario eliminado'}
    else
      render :json => {:status => :error, :message => 'Error eliminando al usuario'}
    end
  end

  def user_params
    params.permit(:name, :nickname, :password, :email, :puntuacion, :categoria)
  end

end
