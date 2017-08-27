class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :nickname, :password, :puntuacion, :categoria
end
