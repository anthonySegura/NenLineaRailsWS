
class Coordenada
    # Getters
    attr_reader :rowPosition, :columnPosition
    def initialize(row, column)
        @rowPosition = row
        @columnPosition = column
    end
end