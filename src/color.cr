module CRT
  class Color
    class InvalidMatrix < Exception
      def initialize(mat : Matrix)
        super "Cannot create color with matrix #{mat} of size #{mat.size}."
      end
    end

    def initialize(r : Float64, g : Float64, b : Float64)
      @_matrix = Matrix.new([[r],[g],[b]])
    end

    def initialize(@_matrix : Matrix)
      raise InvalidMatrix.new(@_matrix) unless @_matrix.size == [3,1]
    end

    def r
      @_matrix[0][0]
    end

    def g
      @_matrix[1][0]
    end

    def b
      @_matrix[2][0]
    end

    def to_matrix
      @_matrix
    end

    def ==(c : Color)
      @_matrix == c.to_matrix
    end

    def +(c : Color)
      Color.new(@_matrix + c.to_matrix)
    end

    def -(c : Color)
      Color.new(@_matrix - c.to_matrix)
    end

    def *(d : Float64)
      Color.new(@_matrix * d)
    end

    def *(c : Color)
      Color.new(
        Matrix.new([
          [r * c.r],
          [g * c.g],
          [b * c.b]
        ])
      )
    end
  end
end
