require 'test_helper'

class SesionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sesion = sesions(:one)
  end

  test "should get index" do
    get sesions_url, as: :json
    assert_response :success
  end

  test "should create sesion" do
    assert_difference('Sesion.count') do
      post sesions_url, params: { sesion: { n2win: @sesion.n2win, n_partidas: @sesion.n_partidas, tam_tablero: @sesion.tam_tablero, tiempo_jugada: @sesion.tiempo_jugada } }, as: :json
    end

    assert_response 201
  end

  test "should show sesion" do
    get sesion_url(@sesion), as: :json
    assert_response :success
  end

  test "should update sesion" do
    patch sesion_url(@sesion), params: { sesion: { n2win: @sesion.n2win, n_partidas: @sesion.n_partidas, tam_tablero: @sesion.tam_tablero, tiempo_jugada: @sesion.tiempo_jugada } }, as: :json
    assert_response 200
  end

  test "should destroy sesion" do
    assert_difference('Sesion.count', -1) do
      delete sesion_url(@sesion), as: :json
    end

    assert_response 204
  end
end
