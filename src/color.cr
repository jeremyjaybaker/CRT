module CRT
  struct Color
    class InvalidMatrix < Exception
      def initialize(mat : Matrix)
        super "Cannot create color with matrix #{mat} of size #{mat.size}."
      end
    end

    def initialize(r : Float64, g : Float64, b : Float64)
      @_matrix = Matrix.new([[r],[g],[b]])
    end

    def initialize(@_matrix : Matrix)
      validate!
    end

    def initialize(arr : Array(Array(Float64)))
      @_matrix = Matrix.new(arr)
      validate!
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

    def self.rand
      new [[Random.rand],[Random.rand],[Random.rand]]
    end

    def self.black
      new [[0.0],[0.0],[0.0]]
    end

    def self.grey
      new [[0.312],[0.312],[0.312]]
    end

    def self.white
      new [[1.0],[1.0],[1.0]]
    end

    def self.red
      new [[1.0], [0.0], [0.0]]
    end

    def to_matrix
      @_matrix
    end

    def to_a
      @_matrix.to_a
    end

    def ==(c : Color)
      @_matrix == c.to_matrix
    end

    def clamp
      Color.new([
        [r.clamp(0.0,1.0)],
        [g.clamp(0.0,1.0)],
        [b.clamp(0.0,1.0)]
      ])
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
      Color.new([
        [r * c.r],
        [g * c.g],
        [b * c.b]
      ])
    end

    private def validate!
      raise InvalidMatrix.new(@_matrix) unless @_matrix.size == [3,1]
    end
  end
end
