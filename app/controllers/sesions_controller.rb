class SesionsController < ApplicationController
  before_action :set_sesion, only: [:show, :update, :destroy]

  # GET /sesions
  def index
    @sesions = Sesion.all

    render json: @sesions
  end

  # GET /sesions/1
  def show
    render json: @sesion
  end

  # POST /sesions
  def create
    @sesion = Sesion.new(sesion_params)

    if @sesion.save
      render json: @sesion, status: :created, location: @sesion
    else
      render json: @sesion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sesions/1
  def update
    if @sesion.update(sesion_params)
      render json: @sesion
    else
      render json: @sesion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sesions/1
  def destroy
    @sesion.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sesion
      @sesion = Sesion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sesion_params
      params.permit(:n_partidas, :n2win, :tiempo_jugada, :tam_tablero)
    end
end
